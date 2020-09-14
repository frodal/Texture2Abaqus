%% Main script for extracting or generating texture to FEM and writing appropriate initial conditions for CP-FEM
% Requires:
%   MTEX (Available here:
%   http://mtex-toolbox.github.io/download.html)

clf
close all
clear
clc

%% Input

% Should the texture used be random?
shouldGenerateRandomTexture   = false; % true or false
shouldGenerateTextureFromOri  = false; % true or false
shouldGenerateTextureFromXray = true; % true or false

% Folder where the Abaqus input file is located and its name
Abapath='../input/';
Abainput='Smooth.inp';

% Folder where the texture file(s) are located
Texpath=Abapath;

% The name of the Auswert texture file
Texinput='Texture.ori';

% The polefigure data prefix
fnamesPrefix = '6063';

% Number of solution-dependent state variables (SDVs)
nStatev = 30;
nDelete = 30;

%% Reading Abaqus input file
% Read Abaqus file to find number of parts, parts name and lists of
% element numbers
[pID,pName,element]=readinput([Abapath,Abainput]);

% pID=1;
% pName{pID}='RubiksCube';
% element{pID}=1:1000;

%% Extracting or generating texture for the model
% Generating Euler angles for each element to match input texture, 1
% element per grain
if shouldGenerateRandomTexture
    [phi1,PHI,phi2]=generateRandomTexture(pID,element);
elseif shouldGenerateTextureFromOri
    [phi1,PHI,phi2]=generateTextureOri([Texpath,Texinput],pID,element);
elseif shouldGenerateTextureFromXray
    fnames = {  fullfile(Texpath, [fnamesPrefix '_pf111_uncorr.dat']),...
                fullfile(Texpath, [fnamesPrefix '_pf200_uncorr.dat']),...
                fullfile(Texpath, [fnamesPrefix '_pf220_uncorr.dat']),...
                fullfile(Texpath, [fnamesPrefix '_pf311_uncorr.dat']) };
    [phi1,PHI,phi2]=generateTextureXray(fnames,pID,element);
end

%% Write additional Abaqus files
% Write initial conditions and element sets to be used in the simulation
writeabaqus(Abapath,Abainput,pID,pName,element,phi1,PHI,phi2,nStatev,nDelete)

disp('Done!')

