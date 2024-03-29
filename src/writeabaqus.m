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
function []=writeabaqus(OutPath,Abapath,Abainput,pID,pName,GrainSet,phi1,PHI,phi2,nStatev,nDelete,inputLines,shouldUseFCTaylorHomogenization,nTaylorGrainsPerIntegrationPoint)

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

NgrainsPerInt = 1;
if shouldUseFCTaylorHomogenization
    NgrainsPerInt = nTaylorGrainsPerIntegrationPoint;
    nStatev = nStatev+6;
end

%%
for k=1:pID
    Nelements = length(phi1{k})/NgrainsPerInt;
    %% Writing Abaqus input
    % Writing initial conditions
    ID=fopen([path,'/',initFileName{k}],'w');

    
    fprintf(ID,'%s \n','**------------------------------------------------------------------------------');
    fprintf(ID,'%s \n','** History card: define Euler angles');
    fprintf(ID,'%s \n','**------------------------------------------------------------------------------');
    fprintf(ID,'%s \n','*Initial conditions, type=SOLUTION');
    fprintf(ID,'%s ','** elset, phi1, PHI, phi2');
    for i=1:Nelements
        if ~isempty(GrainSet{k,i})
            fprintf(ID,'\n');
            fprintf(ID,'%s%d%s%d,','Grain-Set-',k,'-',i);
            for j=1:nStatev*NgrainsPerInt
                if mod(j-1,nStatev)==0 % phi1
                    grainIndex = ceil(j/nStatev);
                    index = i+(grainIndex-1)*Nelements;
                    fprintf(ID,' %6.2f',phi1{k}(index));
                elseif mod(j-2,nStatev)==0 % Phi
                    grainIndex = ceil(j/nStatev);
                    index = i+(grainIndex-1)*Nelements;
                    fprintf(ID,' %6.2f',PHI{k}(index));
                elseif mod(j-3,nStatev)==0 % phi2
                    grainIndex = ceil(j/nStatev);
                    index = i+(grainIndex-1)*Nelements;
                    fprintf(ID,' %6.2f',phi2{k}(index));
                elseif mod(j-nDelete,nStatev)==0 && nDelete>0
                    fprintf(ID,' %d',1);
                else
                    fprintf(ID,' %d',0);
                end
                if j~=nStatev*NgrainsPerInt
                    if mod(j+1,8)==0
                        fprintf(ID,'\n');
                    else
                        fprintf(ID,',');
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
        for i=1:Nelements
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
        for i=1:Nelements
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
initFlag = true;
elsetFlag = true;
for i=2:length(inputLines)-1
    line = inputLines{i};
    if iskey(line,'*End Assembly') && elsetFlag
        elsetFlag = false;
        for k=1:pID
            fprintf(ID,'%s%s\n','*include, input=',elSetFileName{k});
        end
    elseif iskey(line,'*Material') && initFlag
        initFlag = false;
        for k=1:pID
            fprintf(ID,'%s%s\n','*include, input=',initFileName{k});
        end
    end
    fprintf(ID,'%s\n',line);
end
fprintf(ID,'%s',inputLines{end});
fclose(ID);

end