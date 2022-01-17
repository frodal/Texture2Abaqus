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
function grainId = findGrainAtLocation(grains,x,y)

grainId = grains.findByLocation([x,y]);
if isempty(grainId)
    [~,n] = min((grains.x-x).^2+(grains.y-y).^2);
    grainId = grains.findByLocation([grains.x(n),grains.y(n)]);
end
if length(grainId)~=1
    if length(grainId)>1
        grainId = grainId(1);
    elseif length(grainId)<1
        error('Could not find a grain to put here!');
    end
end
end