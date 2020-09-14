function [cp1,cp,cp2]=generateTextureOri(filePath,pID,element)
% Requires:
%   MTEX (Available here:
%   http://mtex-toolbox.github.io/download.html)

disp('Extracting texture from Auswert file')

% This should be a large number (used when texture is loaded from
% a Auswert texture (.ori) file)
Nori=10^7;

% Load Euler angles and weights from Auswert texture file
[phi1,PHI,phi2,A]=importORI(filePath);

cp1=cell(1,pID);
cp=cp1;
cp2=cp1;

if pID~=length(element)
    pID=length(element);
    disp('Warning: The number of parts is not equal to the regions with elements')
end

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
    for j=1:length(element{i})
        n=ceil(Nori*rand);
        cp1{i}(j)=p1(n);
        cp{i}(j)=p(n);
        cp2{i}(j)=p2(n);
    end
end

end