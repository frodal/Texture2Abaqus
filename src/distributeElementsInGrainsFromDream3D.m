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
function [GrainSet,NGrainSets]=distributeElementsInGrainsFromDream3D(pID,element,elementCenter,partDimension,partMinCoordinate,grainSize,dream3Dpath)

disp('Distributing elements in grains')

% Load dream3D data
B=readtable(dream3Dpath,'Format','%d%d%d%d%d%d%d%d%d%d', 'HeaderLines', 7);
B=table2array(B);
B=B';
geom1=B(:);

% Finds the maximum number of grain sets for all parts
NGrainSets=cell(pID);
maxGrainSet = 1;

for id=1:pID
    if length(geom1)==length(element{id})
        NGrainSets{id} = max(geom1);
    else
        N=ceil(partDimension{id}./grainSize);
        NGrainSets{id} = N(1)*N(2)*N(3);
    end
    if NGrainSets{id}>maxGrainSet
        maxGrainSet = NGrainSets{id};
    end
end
%%
% Determines which element belonging to which grain set
GrainSet=cell(pID,maxGrainSet);
for id=1:pID
    if length(geom1)==length(element{id})
        elementCenter1 = elementCenter;
        elementCenter1(3,:)=[];
        elementCenter1(2,:)=[];
        elementCenter2=cell2mat(elementCenter1');
        elementCenter_X=round(elementCenter2(:,1),3);
        elementCenter_Y=round(elementCenter2(:,2),3);
        x_length = unique(elementCenter_X);
        y_length = unique(elementCenter_Y);
        geom = reshape(geom1,size(x_length,1),size(y_length,1))';

        biggest_grain=mode(geom1);
        geom1_mask=geom1==biggest_grain;
        area_big_grain=sum(geom1_mask);

        [~,~,rnk_Y]=unique(elementCenter_Y);
        [~,~,rnk_X]=unique(elementCenter_X);
        element_ID=1:size(elementCenter2,1);
        element_ID=element_ID';
        % associate element number with grain
        grain_ID=zeros(size(elementCenter2,1),1);
        for i=1:max(element_ID)
            x_pos=rnk_X(i);
            y_pos=rnk_Y(i);
           grain_ID(i)=geom(y_pos, x_pos);
        end
        grain_set=zeros(max(grain_ID),area_big_grain);
        for i=1:max(grain_ID)
            mask=grain_ID==i;
            area_grain=sum(mask);
            grain_set(i,1:area_grain)=element_ID(mask)';
        end
         grainset_cell=num2cell(grain_set', [1, 488]);
         reduced_grainset = cellfun(@(c) c(c~=0), grainset_cell, 'uniform', 0);
         grainset_fin = cellfun(@transpose,reduced_grainset,'UniformOutput',false);
         GrainSet(id,:)=grainset_fin;
    else
        N=ceil(partDimension{id}./grainSize);
    
        if id<=length(element)
            for el=element{id}
                if N(1)>1
                    i=ceil((elementCenter{id,el}(1)-partMinCoordinate{id}(1))/grainSize(1));
                else
                    i=1;
                end
                if N(2)>1
                    j=ceil((elementCenter{id,el}(2)-partMinCoordinate{id}(2))/grainSize(2));
                else
                    j=1;
                end
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
end
