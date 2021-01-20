function [partDimension,partMinCoordinate] = correctSymmetry(pID,grainSize,partDimension,partMinCoordinate,symX,symY,symZ)

sym = [symX, symY, symZ];

if symX || symY || symZ
    disp('Correcting for symmetry');
end

% Center elements are halfed to account for symmetry
for i=1:pID
    partMinCoordinate{i} = partMinCoordinate{i}-grainSize.*sym/2;
    for j=1:3
        if sym(j) && isfinite(partMinCoordinate{i}(j))
            partDimension{i}(j) = partDimension{i}(j)+grainSize(j);
        end
    end
end


end