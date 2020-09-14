function [cp1,cp,cp2]=generateRandomTexture(pID,element)
% Requires:
%   MTEX (Available here:
%   http://mtex-toolbox.github.io/download.html)

cp1=cell(1,pID);
cp=cp1;
cp2=cp1;

if pID~=length(element)
    pID=length(element);
    disp('Warning: The number of parts is not equal to the regions with elements')
end

%% generate random texture
disp('Generating random texture')
for i=1:pID
    n=length(element{i});
    try
        [phi1_mtex,Phi_mtex,phi2_mtex] = Euler(calcOrientations(uniformODF,n),'Bunge');
        % converting from radians to degrees
        cp1{i} = phi1_mtex/degree;
        cp{i} = Phi_mtex/degree;
        cp2{i} = phi2_mtex/degree;
    catch
        cp1{i}=360*rand(n,1);
        cp{i}=180*rand(n,1);
        cp2{i}=360*rand(n,1);
        disp('Warning! The generated texture is not exactly random!')
        disp('To generate a better random texture, install MTEX.')
    end
end

end