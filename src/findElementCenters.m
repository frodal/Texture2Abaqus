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
function [elementCenter]=findElementCenters(pID,element,nodeElementID,nodeCoordinate)

disp('Finding element centers')

elementCenter=cell(pID,length(element{1}));
for i=1:pID
    if i<=length(element)
        for elementID=element{i}
            nodeIDs=nodeElementID{i}{elementID};
            N=length(nodeIDs);
            
            elementCenter{i,elementID}=nodeCoordinate{i}{nodeIDs(1)};
            for n=2:N
                elementCenter{i,elementID}=elementCenter{i,elementID}+nodeCoordinate{i}{nodeIDs(n)};
            end
            elementCenter{i,elementID}=elementCenter{i,elementID}./N;
        end
    end
end
end