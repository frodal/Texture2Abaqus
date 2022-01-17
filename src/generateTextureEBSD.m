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
function [phi1, PHI, phi2] = generateTextureEBSD(pID,grains_selected)

disp('Extracting texture from EBSD scan')

phi1=cell(1,pID);
PHI=phi1;
phi2=phi1;
for id=1:pID
    phi1{id}=zeros(max(grains_selected.id),1);
    PHI{id}=zeros(max(grains_selected.id),1);
    phi2{id}=zeros(max(grains_selected.id),1);
    for grainId=grains_selected.id
        phi1{id}(grainId)=grains_selected(grainId).meanOrientation.phi1/degree;
        PHI{id}(grainId)=grains_selected(grainId).meanOrientation.Phi/degree;
        phi2{id}(grainId)=grains_selected(grainId).meanOrientation.phi2/degree;
    end
end

end