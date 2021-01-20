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