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