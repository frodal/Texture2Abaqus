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
%%
function [grains_selected] = importEBSD(fname, EBSDscanPlane, grainMisorientationThreshold, grainSizeThreshold, confidenseIndexThreshold)

disp('Importing EBSD data')

if ~exist(fname, 'file')
    error(['The given file does not exist: "',fname,'"'])
end

%% Import the Data

% Crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('m-3m', [4.04 4.04 4.04], 'mineral', 'Aluminum')};

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','ang',...
  'convertSpatial2EulerReferenceFrame','setting 2');

% Rotate the texture so that the x-y plane is in the material plane of the
% EBSD data
if strcmp(EBSDscanPlane,'ED-ND')
    rot = rotation.byAxisAngle(xvector,90*degree);
    ebsd = rotate(ebsd,rot,'keepXY');
elseif strcmp(EBSDscanPlane,'TD-ND')
    rot = rotation.byAxisAngle(zvector,90*degree);
    ebsd = rotate(ebsd,rot,'keepXY');
    rot = rotation.byAxisAngle(xvector,90*degree);
    ebsd = rotate(ebsd,rot,'keepXY');
end

% Removing measuring points with a confidense index of less than 0.1
ebsd = ebsd(ebsd.ci >= confidenseIndexThreshold);

%% Grain calculations
% compute the grains
[grains,ebsd.grainId,ebsd.mis2mean] = calcGrains(ebsd,'threshold',grainMisorientationThreshold);

% Smooth grain boundaries
grains = smooth(grains,5);
% Select grains larger than grainSizeThreshold pixels
grains_selected = grains(grains.grainSize > grainSizeThreshold);

% Select ebsd data with grains larger than grainSizeThreshold pixels
ebsd_selected = ebsd(grains_selected);

[grains_selected,ebsd_selected.grainId,ebsd_selected.mis2mean] = calcGrains(ebsd_selected,'threshold',grainMisorientationThreshold);
grains_selected = smooth(grains_selected,5);

end