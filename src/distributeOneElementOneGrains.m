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