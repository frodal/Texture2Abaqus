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
function ang=eulerFromRotation(R)

if (abs(abs(R(3,3))-1)>1e-9)
    ang(1) = atan2(R(1,3),-R(2,3))*180/pi;
    ang(2) = acos(R(3,3))*180/pi;
    ang(3) = atan2(R(3,1),R(3,2))*180/pi;
else
	ang(1) = atan2(R(2,1),R(1,1))*180/pi;
    ang(2) = acos(R(3,3))*180/pi;
    ang(3) = 0;
end

if (ang(1)<0)
	ang(1) = ang(1)+360;
end
if (ang(2)<0)
    ang(2) = ang(2)+360;
end
if (ang(3)<0)
    ang(3) = ang(3)+360;
end
end