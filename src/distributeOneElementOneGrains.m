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
function [GrainSet,NGrainSets] = distributeOneElementOneGrains(pID,element)

disp('Distributing elements in grains')

% Finds the maximum number of grain sets for all parts
NGrainSets=cell(pID);
maxGrainSet = 1;
for id=1:pID
    NGrainSets{id} = length(element{id});
    if NGrainSets{id}>maxGrainSet
        maxGrainSet = NGrainSets{id};
    end
end

% Determines which element belonging to which grain set
GrainSet=cell(pID,maxGrainSet);
for id=1:pID
    if id<=NGrainSets{id}
        for i=1:NGrainSets{id}
            GrainSet{id,i}(end+1)=element{id}(i);
        end
    end
end
end