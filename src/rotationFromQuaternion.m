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
function R=rotationFromQuaternion(q)

R=[q.a^2+q.b^2-q.c^2-q.d^2, 2*(q.b*q.c-q.a*q.d), 2*(q.a*q.c+q.b*q.d);
   2*(q.b*q.c+q.a*q.d), q.a^2-q.b^2+q.c^2-q.d^2, 2*(q.c*q.d-q.a*q.b);
   2*(q.b*q.d-q.a*q.c), 2*(q.a*q.b+q.c*q.d), q.a^2-q.b^2-q.c^2+q.d^2];
end