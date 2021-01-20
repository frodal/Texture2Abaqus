function []=writeabaqus(OutPath,Abapath,Abainput,pID,pName,GrainSet,phi1,PHI,phi2,nStatev,nDelete,inputLines)

disp('Writing new Abaqus files')

if strcmp(OutPath,Abapath)
    path = [Abapath,'output'];
else
    path = OutPath(1:end-1);
end

if ~exist(path,'dir')
    mkdir(path)
end

initFileName = cell(1,pID);
elSetFileName = cell(1,pID);

for k=1:pID
    if strcmp(pName{k},'')
        initFileName{k}  = ['Init_',Abainput];
        elSetFileName{k} = ['Elset_',Abainput];
    else
        initFileName{k}  = ['Init_',pName{k},'_',Abainput];
        elSetFileName{k} = ['Elset_',pName{k},'_',Abainput];
    end
end

%%
for k=1:pID
    %% Writing Abaqus input
    % Writing initial conditions
    ID=fopen([path,'/',initFileName{k}],'w');

    
    fprintf(ID,'%s \n','**------------------------------------------------------------------------------');
    fprintf(ID,'%s \n','** History card: define Euler angles');
    fprintf(ID,'%s \n','**------------------------------------------------------------------------------');
    fprintf(ID,'%s \n','*Initial conditions, type=SOLUTION');
    fprintf(ID,'%s ','** elset, phi1, PHI, phi2');
    
    for i=1:length(phi1{k})
        if ~isempty(GrainSet{k,i})
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
    end
    fclose(ID);
    
    % Writing Element sets , i.e., each element is a seperate grain
    ID=fopen([path,'/',elSetFileName{k}],'w');
    
    fprintf(ID,'%s \n','**------------------------------------------------------------------------------');
    fprintf(ID,'%s \n','** Element sets');
    fprintf(ID,'%s ','**------------------------------------------------------------------------------');
    
    if strcmp(pName{k},'')
        for i=1:length(phi1{k})
            if ~isempty(GrainSet{k,i})
                fprintf(ID,'\n');
                fprintf(ID,'%s%d%s%d\n','*Elset, elset=Grain-Set-',k,'-',i);
                for j=1:length(GrainSet{k,i})
                    if j==length(GrainSet{k,i})
                        fprintf(ID,' %d',GrainSet{k,i}(j));
                    elseif mod(j,16)==0
                        fprintf(ID,' %d\n',GrainSet{k,i}(j));
                    else
                        fprintf(ID,' %d,',GrainSet{k,i}(j));
                    end
                end
            end
        end
    else
        for i=1:length(phi1{k})
            if ~isempty(GrainSet{k,i})
                fprintf(ID,'\n');
                fprintf(ID,'%s%d%s%d%s%s%s\n','*Elset, elset=Grain-Set-',k,'-',i,', instance=',pName{k},'-1');
                for j=1:length(GrainSet{k,i})
                    if j==length(GrainSet{k,i})
                        fprintf(ID,' %d',GrainSet{k,i}(j));
                    elseif mod(j,16)==0
                        fprintf(ID,' %d\n',GrainSet{k,i}(j));
                    else
                        fprintf(ID,' %d,',GrainSet{k,i}(j));
                    end
                end
            end
        end
    end
    fclose(ID);
end

% Creates a new Abaqus input file with the necessary includes
ID=fopen([path,'/',Abainput],'w');
for i=2:length(inputLines)-1
    line = inputLines{i};
    if iskey(line,'*End Assembly')
        for k=1:pID
            fprintf(ID,'%s%s\n','*include, input=',elSetFileName{k});
        end
    elseif iskey(line,'*Material')
        for k=1:pID
            fprintf(ID,'%s%s\n','*include, input=',initFileName{k});
        end
    end
    fprintf(ID,'%s\n',line);
end
fprintf(ID,'%s',inputLines{end});
fclose(ID);

end