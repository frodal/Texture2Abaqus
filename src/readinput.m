function [pID,pName,elementID,nodeElementID,nodeID,nodeCoordinate,lines]=readinput(filePath)

disp('Reading the Abaqus input file')

if ~exist(filePath, 'file')
    error(['The given file does not exist: "',filePath,'"'])
end

ID=fopen(filePath,'r');

pID=0;
r=-1;
firstElementInPart=false;
firstNodeInPart=false;
lines = cell(1,1);
lines{1} = '';

while ~feof(ID)
    line = fgetl(ID);
    lines{end+1} = line;
    if iskey(line,'*Part')
        firstElementInPart=true;
        firstNodeInPart=true;
        pID=pID+1;
        pName{pID}=line(13:end);
    elseif iskey(line,'*Element,')
        if firstElementInPart
            r=0;
            firstElementInPart=false;
        else
            r=1;
        end
    elseif iskey(line,'*Node') && ~iskey(line,'*Node ')
        if pID==0
            firstElementInPart=true;
            firstNodeInPart=true;
            pID=pID+1;
            pName{pID}='';
        end
        if firstNodeInPart==true
            r=2;
            firstNodeInPart=false;
        else
            r=3;
        end
    elseif iskeyword(line) || iscomment(line)
        r=-1;
    end
    if r==0 && ~iskeyword(line)
        temp=strsplit(line,',');
        elementID{pID}(1)=str2double(temp{1});
        for i=2:length(temp)
            nodeElementID{pID}{elementID{pID}(end)}(i-1)=str2double(temp{i});
        end
        r=1;
    elseif r==1 && ~iskeyword(line)
        temp=strsplit(line,',');
        elementID{pID}(end+1)=str2double(temp{1});
        for i=2:length(temp)
            nodeElementID{pID}{elementID{pID}(end)}(i-1)=str2double(temp{i});
        end
    elseif r==2 && ~iskeyword(line)
        temp=strsplit(line,',');
        nodeID{pID}(1)=str2double(temp{1});
        for i=2:length(temp)
            nodeCoordinate{pID}{nodeID{pID}(end)}(i-1)=str2double(temp{i});
        end
        r=3;
    elseif r==3 && ~iskeyword(line)
        temp=strsplit(line,',');
        nodeID{pID}(end+1)=str2double(temp{1});
        for i=2:length(temp)
            nodeCoordinate{pID}{nodeID{pID}(end)}(i-1)=str2double(temp{i});
        end
    end
end

fclose(ID);
end