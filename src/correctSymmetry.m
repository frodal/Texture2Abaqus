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