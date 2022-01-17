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
function q=randomQuaternion()
z=2;
w=2;
while (z > 1)
    x = 2*rand()-1;
    y = 2*rand()-1;
    z = x*x + y*y;
end
while (w > 1)
    u = 2*rand()-1;
    v = 2*rand()-1;
    w = u*u + v*v;
end
s = sqrt((1-z) / w);

q.a = x;
q.b = y;
q.c = s*u;
q.d = s*v;

% q = quaternion(x, y, s*u, s*v);

end