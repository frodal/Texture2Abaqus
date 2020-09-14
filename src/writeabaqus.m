function []=writeabaqus(Abapath,Abainput,pID,pName,element,phi1,PHI,phi2,nStatev,nDelete)

disp('Writing new Abaqus files')

path=[Abapath,'output'];
pathori=[path,'\ORI'];

GaussianSmoothing=7.0;
SeriesRank=23;

if ~exist(path,'dir')
    mkdir(path)
end
if ~exist(pathori,'dir')
    mkdir(pathori)
end

if pID~=length(element)
    pID=length(element);
end
%%
for k=1:pID
    %% Writing Abaqus input
    % Writing initial conditions
    if strcmp(pName{k},'')
        ID=fopen([path,'\Init_',Abainput],'w');
    else
        ID=fopen([path,'\Init_',pName{k},'_',Abainput],'w');
    end
    
    fprintf(ID,'%s \n','**------------------------------------------------------------------------------');
    fprintf(ID,'%s \n','** History card: define Euler angles');
    fprintf(ID,'%s \n','**------------------------------------------------------------------------------');
    fprintf(ID,'%s \n','*Initial conditions, type=SOLUTION');
    fprintf(ID,'%s ','** elset, phi1, PHI, phi2');
    
    for i=1:length(phi1{k})
        fprintf(ID,'\n');
        fprintf(ID,'%s%d%s%d, %6.2f, %6.2f, %6.2f,','Grain-Set-',k,'-',i,phi1{k}(i),PHI{k}(i),phi2{k}(i));
        for j=4:nStatev
            if j==nDelete
                if j==nStatev
                    fprintf(ID,' %d',1);
                elseif mod(j+1,8)==0
                    fprintf(ID,' %d\n',1);
                else
                    fprintf(ID,' %d,',1);
                end
            else
                if j==nStatev
                    fprintf(ID,' %d',0);
                elseif mod(j+1,8)==0
                    fprintf(ID,' %d\n',0);
                else
                    fprintf(ID,' %d,',0);
                end
            end
        end
    end
    fclose(ID);
    
    % Writing Element sets , i.e., each element is a seperate grain
    if strcmp(pName{k},'')
        ID=fopen([path,'\Elset_',Abainput],'w');
    else
        ID=fopen([path,'\Elset_',pName{k},'_',Abainput],'w');
    end
    
    fprintf(ID,'%s \n','**------------------------------------------------------------------------------');
    fprintf(ID,'%s \n','** Element sets');
    fprintf(ID,'%s ','**------------------------------------------------------------------------------');
    
    if strcmp(pName{k},'')
        for i=1:length(element{k})
            fprintf(ID,'\n');
            fprintf(ID,'%s%d%s%d\n','*Elset, elset=Grain-Set-',k,'-',i);
            fprintf(ID,' %d',element{k}(i));
        end
    else
        for i=1:length(element{k})
            fprintf(ID,'\n');
            fprintf(ID,'%s%d%s%d%s%s%s\n','*Elset, elset=Grain-Set-',k,'-',i,', instance=',pName{k},'-1');
            fprintf(ID,' %d',element{k}(i));
        end
    end
    fclose(ID);
    
    %% Writing ori file
    if strcmp(pName{k},'')
        ID=fopen([pathori,'\Init.ori'],'w');
    else
        ID=fopen([pathori,'\Init_',pName{k},'.ori'],'w');
    end
    
    fprintf(ID,'%s \n','TEX      EPS 0.000   texture from xxx');
    fprintf(ID,'%s %2d \n','PHI2',SeriesRank);
    fprintf(ID,'%d %3d %2.1f ',length(phi1{k}),0,GaussianSmoothing);
    for i=1:length(phi1{k})
        fprintf(ID,'\n');
        fprintf(ID,'%6.2f %6.2f %6.2f %8.6f %5.2f',phi1{k}(i),PHI{k}(i),phi2{k}(i),1,0);
    end
    fclose(ID);
end
end