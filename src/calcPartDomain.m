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
function [partDimension,partMinCoordinate]=calcPartDomain(pID,element,nodeElementID,nodeCoordinate,grainSize)

disp('Calculating part domain')

partDimension = cell(pID);
partMinCoordinate = cell(pID);
for i=1:pID
    minPos = [inf, inf, inf];
    maxPos = [-inf,-inf,-inf];
    if i<=length(element)
        for elementID=element{i}
            for nodeID=nodeElementID{i}{elementID}
                currentNodePos = nodeCoordinate{i}{nodeID};
                for j=1:length(currentNodePos)
                    if currentNodePos(j)<minPos(j)
                        minPos(j) = currentNodePos(j);
                    end
                    if currentNodePos(j)>maxPos(j)
                        maxPos(j) = currentNodePos(j);
                    end
                end
            end
        end
        partMinCoordinate{i} = minPos;
        partDimension{i} = maxPos-minPos;
        for j=1:3
            if ~isfinite(partDimension{i}(j)) || partDimension{i}(j)==0
                partDimension{i}(j) = grainSize(j);
            end
        end
    end
end
end