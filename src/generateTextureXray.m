%     Texture2Abaqus
%     Copyright (C) 2017-2022 Bj�rn H�kon Frodal
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
function [cp1,cp,cp2]=generateTextureXray(fnames,pID,N,shouldUseFCTaylorHomogenization,nTaylorGrainsPerIntegrationPoint)

%% generate texture from X-ray data
disp('Loading polefigure data')

for i=1:length(fnames)
    if ~exist(fnames{i}, 'file')
        error(['The given file does not exist: "',fnames{i},'"'])
    end
end

%Import pole figure data and create PoleFigure object
cs = crystalSymmetry('m-3m',[4.04 4.04 4.04],'mineral','Al');

% Specimen symmetry
ss = specimenSymmetry('1'); % Triclinic
ssO = specimenSymmetry('orthorhombic');

h = {
    Miller(1,1,1,cs),...
    Miller(2,0,0,cs),...
    Miller(2,2,0,cs),...
    Miller(3,1,1,cs)};

% Load pole figures separately
columnNames = {'Polar Angle','Azimuth Angle','Intensity'};
pf1 = loadPoleFigure_generic(fnames{1},'ColumnNames',columnNames);
pf2 = loadPoleFigure_generic(fnames{2},'ColumnNames',columnNames);
pf3 = loadPoleFigure_generic(fnames{3},'ColumnNames',columnNames);
pf4 = loadPoleFigure_generic(fnames{4},'ColumnNames',columnNames);

% Construct pole figure object of the four pole figures
intensities = {
    pf1.intensities,...
    pf2.intensities,...
    pf3.intensities,...
    pf4.intensities};
pfs = PoleFigure(h,pf1.r,intensities,cs,ss);

%% Calculate the ODF using default settings
disp('Calculating ODF from polefigure data')
odf = calcODF(pfs);

% Set correct specimen symmetry for calculation of texture strength
odf.SS = ssO;

%% Extract orientations from ODF

[cp1,cp,cp2]=generateTextureFromMTEXODF(odf,pID,N,shouldUseFCTaylorHomogenization,nTaylorGrainsPerIntegrationPoint);

end