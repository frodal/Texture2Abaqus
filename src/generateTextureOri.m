%     Texture2Abaqus
%     Copyright (C) 2017-2021 Bjørn Håkon Frodal
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
function [cp1,cp,cp2]=generateTextureOri(filePath,pID,N)

disp('Extracting texture from Auswert file')

if ~exist(filePath, 'file')
    error(['The given file does not exist: "',filePath,'"'])
end

% This should be a large number (used when texture is loaded from
% a Auswert texture (.ori) file)
Nori=10^7;

% Load Euler angles and weights from Auswert texture file
[phi1,PHI,phi2,A]=importORI(filePath);

cp1=cell(1,pID);
cp=cp1;
cp2=cp1;

%% generate texture from Auswert texture file
A=A*Nori/sum(A);
A=round(A);
Nori=sum(A);

p1=[];
p=p1;
p2=p1;

for i=1:length(phi1)
    p1(end+1:end+A(i))=phi1(i);
    p(end+1:end+A(i))=PHI(i);
    p2(end+1:end+A(i))=phi2(i);
end

%

for i=1:pID
    for j=1:N{i}
        n=ceil(Nori*rand);
        cp1{i}(j)=p1(n);
        cp{i}(j)=p(n);
        cp2{i}(j)=p2(n);
    end
end

end