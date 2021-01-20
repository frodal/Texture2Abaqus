function [phi1, PHI, phi2] = generateTextureEBSD(pID,grains_selected)

disp('Extracting texture from EBSD scan')

phi1=cell(1,pID);
PHI=phi1;
phi2=phi1;
for id=1:pID
    phi1{id}=zeros(max(grains_selected.id),1);
    PHI{id}=zeros(max(grains_selected.id),1);
    phi2{id}=zeros(max(grains_selected.id),1);
    for grainId=grains_selected.id
        phi1{id}(grainId)=grains_selected(grainId).meanOrientation.phi1/degree;
        PHI{id}(grainId)=grains_selected(grainId).meanOrientation.Phi/degree;
        phi2{id}(grainId)=grains_selected(grainId).meanOrientation.phi2/degree;
    end
end

end