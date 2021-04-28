%     Texture2Abaqus
%     Copyright (C) 2017-2021 Bjørn Håkon Frodal
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program. If not, see <https://www.gnu.org/licenses/>.
%
%% Main script for extracting or generating texture to FEM and writing appropriate initial conditions for CP-FEM
% Requires:
%   MTEX (Available here: http://mtex-toolbox.github.io/download.html)
%   The Abaqus mesh should be dependent, i.e., meshed on the part

clf
close all
clear
clc

%% Input

% Number of solution-dependent state variables (SDVs) and SDV number controlling element deletion
nStatev = 30;
nDelete = 30;

% Should one grain be represented by one element or should the elements be 
% distributed by the grain size defined below or the EBSD data
useOneElementPerGrain = false; % true or false
% Approximate grain size in the x, y and z direction, not used for EBSD
grainSize = [0.3, 0.3, 0.3];
% Symmetry axes used with above grain size
symX = false; % true or false
symY = false; % true or false
symZ = false; % true or false

% Should the texture used be random or generated from orientations data, X-ray polefigure data or EBSD data?
shouldGenerateRandomTexture   = true; % true or false
shouldGenerateTextureFromOri  = false; % true or false
shouldGenerateTextureFromXray = false; % true or false
shouldGenerateTextureFromEBSD = false;  % true or false

% Folder where the Abaqus input file is located and its name
Abapath  = '../input/';
Abainput = 'Smooth.inp';

% Output folder where the new Abaqus input files are written
OutPath = '../output/';

% Folder where the texture file(s) are located
Texpath='../texture/';
% The name of the Auswert texture (orientation) file
ORIinput='Texture.ori';
% The polefigure data prefix (X-ray data)
fnamesPrefix = 'Xray';
% The name of the EBSD data file
EBSDinput = 'EBSD.ang';

% Should the x or y-axis of the EBSD data be flipped, and/or streched to 
% fit the geometry for the Abaqus files generated
flipX   = false; % true or false
flipY   = false; % true or false
strechX = false; % true or false
strechY = false; % true or false
% This script assumes that your model is modelled in the x-y plane in
% Abaqus when generating texture from EBSD data. To model the correct
% material plane, the texture is rotated so that the x-y plane in Abaqus is
% the x-y plane of the EBSD data, i.e., if the EBSD scan is performed in
% another plane than ED-TD, the texture is rotated in the generated files.
% F.ex. if your EBSD scan is in the ED-ND plane the texture is rotated such
% that the x-y plane in Abaqus corresponds to the ED-ND plane (x=ED, y=ND)
EBSDscanPlane = 'ED-ND'; % possible values 'ED-TD', 'ED-ND', 'TD-ND'

% Grain cutoff size in pixels for the EBSD data, i.e., grains smaller than
% or equal to this value will be removed
grainSizeThreshold = 1;
% Removing EBSD measuring points with a confidense index of less than confidenseIndexThreshold
confidenseIndexThreshold = 0.1;
% EBSD misorientation thresold between different grains
grainMisorientationThreshold = 5*degree;

%% Checking for valid input

validateInput(nStatev,nDelete,useOneElementPerGrain,grainSize,symX,symY,symZ,shouldGenerateRandomTexture,...
              shouldGenerateTextureFromOri,shouldGenerateTextureFromXray,shouldGenerateTextureFromEBSD,...
              flipX,flipY,strechX,strechY,EBSDscanPlane,grainSizeThreshold,confidenseIndexThreshold,grainMisorientationThreshold);

%% Reading Abaqus input file, extracting information and distributing elements in grains
% Read Abaqus file to find number of parts, parts name, lists of
% element numbers, list of nodes and their coordinates
[pID,pName,element,nodeElementID,nodeID,nodeCoordinate,inputLines] = readinput([Abapath,Abainput]);

% Finds the element coordinate centers
[elementCenter] = findElementCenters(pID,element,nodeElementID,nodeCoordinate);

% Finds the dimensions of the Abaqus part domain
[partDimension,partMinCoordinate] = calcPartDomain(pID,element,nodeElementID,nodeCoordinate,grainSize);

% Grains along symmetry boundaries are "halfed"
if ~shouldGenerateTextureFromEBSD
    [partDimension,partMinCoordinate] = correctSymmetry(pID,grainSize,partDimension,partMinCoordinate,symX,symY,symZ);
end

% Determines which element belonging to which grain set
if shouldGenerateTextureFromEBSD
    grainsEBSD = importEBSD([Texpath,EBSDinput], EBSDscanPlane, grainMisorientationThreshold, grainSizeThreshold, confidenseIndexThreshold);
    [GrainSet,NGrainSets] = distributeElementsInGrainsFromEBSD(pID,element,elementCenter,partDimension,partMinCoordinate,grainsEBSD,flipX,flipY,strechX,strechY);
elseif useOneElementPerGrain
    [GrainSet,NGrainSets] = distributeOneElementOneGrains(pID,element);
else
    [GrainSet,NGrainSets] = distributeElementsInGrains(pID,element,elementCenter,partDimension,partMinCoordinate,grainSize);
end

%% Extracting or generating texture for the model
% Generating Euler angles
if shouldGenerateRandomTexture+shouldGenerateTextureFromOri+shouldGenerateTextureFromXray+shouldGenerateTextureFromEBSD~=1
    error('One of the texture flags should be true, while the others should be false!');
elseif shouldGenerateRandomTexture
    [phi1, PHI, phi2] = generateRandomTexture(pID,NGrainSets);
elseif shouldGenerateTextureFromOri
    [phi1, PHI, phi2] = generateTextureOri([Texpath,ORIinput],pID,NGrainSets);
elseif shouldGenerateTextureFromXray
    fnames = {  fullfile(Texpath, [fnamesPrefix '_pf111_uncorr.dat']),...
                fullfile(Texpath, [fnamesPrefix '_pf200_uncorr.dat']),...
                fullfile(Texpath, [fnamesPrefix '_pf220_uncorr.dat']),...
                fullfile(Texpath, [fnamesPrefix '_pf311_uncorr.dat']) };
    [phi1, PHI, phi2] = generateTextureXray(fnames,pID,NGrainSets);
elseif shouldGenerateTextureFromEBSD
    [phi1, PHI, phi2] = generateTextureEBSD(pID,grainsEBSD);
end

%% Write additional Abaqus files
% Write initial conditions and element sets to be used in the simulation
writeabaqus(OutPath,Abapath,Abainput,pID,pName,GrainSet,phi1,PHI,phi2,nStatev,nDelete,inputLines)

disp('Done!')

