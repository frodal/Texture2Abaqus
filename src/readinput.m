function [pID,pName,element]=readinput(path)

disp('Reading the Abaqus input file')

ID=fopen(path,'r');

pID=0;
r=-1;
firstInPart=false;

while ~feof(ID)
    line = fgetl(ID);
    if iskey(line,'*Part')
        firstInPart=true;
        pID=pID+1;
        pName{pID}=line(13:end);
    elseif iskey(line,'*Element,')
        if pID==0
            firstInPart=true;
            pID=pID+1;
            pName{pID}='';
        end
        if firstInPart
            r=0;
            firstInPart=false;
        else
            r=1;
        end
    elseif iskeyword(line) || iscomment(line)
        r=-1;
    end
    if r==0 && ~iskeyword(line)
        temp=strsplit(line,',');
        element{pID}(1)=str2double(temp{1});
        r=1;
    elseif r==1 && ~iskeyword(line)
        temp=strsplit(line,',');
        element{pID}(end+1)=str2double(temp{1});
    end
end

fclose(ID);
end