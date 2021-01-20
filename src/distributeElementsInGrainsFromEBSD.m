function [GrainSet,NGrainSets]=distributeElementsInGrainsFromEBSD(pID,element,elementCenter,partDimension,partMinCoordinate,grains,flipX,flipY,strechX,strechY)

disp('Distributing elements in grains')

% Finds the maximum number of grain sets for all parts
NGrainSets =cell(pID);
maxGrainSet = max(grains.id);
maxGrainsX = max(grains.x);
maxGrainsY = max(grains.y);
minGrainsX = min(grains.x);
minGrainsY = min(grains.y);
grainXdim = maxGrainsX-minGrainsX;
grainYdim = maxGrainsY-minGrainsY;
for id=1:pID
    NGrainSets{id} = maxGrainSet;
end

factor = 1000; % um/mm assume that the EBSD data is in microns and that the Abaqus unit is mm

% Determines which element belonging to which grain set
GrainSet=cell(pID,maxGrainSet);
% GrainSetMirror=cell(pID,maxGrainSet);
for id=1:pID
    if id<=length(element)
        k=0;
        total = length(element{id});
        if strechX && strechY
            factor = min(grainXdim/partDimension{id}(1),grainYdim/partDimension{id}(2));
        elseif strechX
            factor=grainXdim/partDimension{id}(1);
        elseif strechY
            factor=grainYdim/partDimension{id}(2);
        end
        for el=element{id}
            % Assume that the model is 2D or semi 2D, i.e., 3D with major axes in the x-y plane
            x_fem=elementCenter{id,el}(1);%-partMinCoordinate{id}(1);
            y_fem=elementCenter{id,el}(2);%-partMinCoordinate{id}(2);
            
            if mod(floor(x_fem*factor/grainXdim),2)==flipX
                x=minGrainsX+mod(x_fem*factor,grainXdim);
            else
                x=maxGrainsX-mod(x_fem*factor,grainXdim);
            end
            
            if mod(floor(y_fem*factor/grainYdim),2)==flipY
                y=minGrainsY+mod(y_fem*factor,grainYdim);
            else
                y=maxGrainsY-mod(y_fem*factor,grainYdim);
            end
            
            grainId = findGrainAtLocation(grains,x,y);

            GrainSet{id,grainId}(end+1) = el;
            
            progress(k,total)
            k=k+1;
        end
    end
end
end