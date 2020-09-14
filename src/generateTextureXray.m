function [cp1,cp,cp2]=generateTextureXray(fnames,pID,element)
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

%% generate texture from X-ray data
disp('Loading polefigure data')
%Import pole figure data and create PoleFigure object
cs = crystalSymmetry('m-3m',[4.04 4.04 4.04],'mineral','Al');

% Specimen symmetry
ss = specimenSymmetry('1'); % Triclinic
ssO = specimenSymmetry('orthorhombic');

h = {
    Miller(1,1,1,cs),...
    Miller(2,0,0,cs),...
    Miller(2,2,0,cs),...
    Miller(3,1,1,cs)};

% Load pole figures separately
columnNames = {'Polar Angle','Azimuth Angle','Intensity'};
pf1 = loadPoleFigure_generic(fnames{1},'ColumnNames',columnNames);
pf2 = loadPoleFigure_generic(fnames{2},'ColumnNames',columnNames);
pf3 = loadPoleFigure_generic(fnames{3},'ColumnNames',columnNames);
pf4 = loadPoleFigure_generic(fnames{4},'ColumnNames',columnNames);

% Construct pole figure object of the four pole figures
intensities = {
    pf1.intensities,...
    pf2.intensities,...
    pf3.intensities,...
    pf4.intensities};
pfs = PoleFigure(h,pf1.r,intensities,cs,ss);

%% Calculate the ODF using default settings
disp('Calculating ODF from polefigure data')
odf = calcODF(pfs);

% Set correct specimen symmetry for calculation of texture strength
odf.SS = ssO;

%% Extract orientations from ODF
disp('Extracting orientations from ODF')

progress(0,pID)
for i=1:pID
    n=length(element{i});
    [phi1_mtex,Phi_mtex,phi2_mtex] = Euler(calcOrientations(odf,n),'Bunge');
    % converting from radians to degrees
    cp1{i} = phi1_mtex/degree;
    cp{i} = Phi_mtex/degree;
    cp2{i} = phi2_mtex/degree;
    progress(i,pID)
end

end