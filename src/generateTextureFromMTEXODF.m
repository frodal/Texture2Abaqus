%     Texture2Abaqus
%     Copyright (C) 2017-2022 Bjørn Håkon Frodal
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
function [cp1,cp,cp2]=generateTextureFromMTEXODF(odf,pID,N,shouldUseFCTaylorHomogenization,nTaylorGrainsPerIntegrationPoint)
% Requires:
%   MTEX (Available here:
%   http://mtex-toolbox.github.io/download.html)

cp1=cell(1,pID);
cp=cp1;
cp2=cp1;

NgrainsPerInt = 1;
if shouldUseFCTaylorHomogenization
    NgrainsPerInt = nTaylorGrainsPerIntegrationPoint;
end

%% Extract orientations from ODF
disp('Extracting orientations from ODF')

progress(0,pID)
for i=1:pID
    n=N{i}*NgrainsPerInt;
    [phi1_mtex,Phi_mtex,phi2_mtex] = Euler(calcOrientations(odf,n),'Bunge');
    % converting from radians to degrees
    cp1{i} = phi1_mtex/degree;
    cp{i} = Phi_mtex/degree;
    cp2{i} = phi2_mtex/degree;
    progress(i,pID)
end

end