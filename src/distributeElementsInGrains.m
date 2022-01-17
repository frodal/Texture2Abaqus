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
function [GrainSet,NGrainSets]=distributeElementsInGrains(pID,element,elementCenter,partDimension,partMinCoordinate,grainSize)

disp('Distributing elements in grains')

% Finds the maximum number of grain sets for all parts
NGrainSets=cell(pID);
maxGrainSet = 1;
for id=1:pID
    N=ceil(partDimension{id}./grainSize);
    NGrainSets{id} = N(1)*N(2)*N(3);
    if NGrainSets{id}>maxGrainSet
        maxGrainSet = NGrainSets{id};
    end
end

% Determines which element belonging to which grain set
GrainSet=cell(pID,maxGrainSet);
for id=1:pID
    
    N=ceil(partDimension{id}./grainSize);
    
    if id<=length(element)
        for el=element{id}
            i=ceil((elementCenter{id,el}(1)-partMinCoordinate{id}(1))/grainSize(1));
            j=ceil((elementCenter{id,el}(2)-partMinCoordinate{id}(2))/grainSize(2));
            if N(3)>1
                k=ceil((elementCenter{id,el}(3)-partMinCoordinate{id}(3))/grainSize(3));
            else
                k=1;
            end
            GrainSet{id,i+(j-1)*N(1)+(k-1)*N(1)*N(2)}(end+1)=el;
        end
    end
end
end