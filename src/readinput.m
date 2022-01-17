%     Texture2Abaqus
%     Copyright (C) 2017-2022 Bj�rn H�kon Frodal
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
        if firstElementInPart
            pID=pID-1; % delete empty part
        end
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

% Delete an empty part
if firstElementInPart
    pID=pID-1;
    pName = pName(1:pID);
    elementID = elementID(1:pID);
    nodeElementID = nodeElementID(1:pID);
    nodeID = nodeID(1:pID);
    nodeCoordinate = nodeCoordinate(1:pID);
end

fclose(ID);
end