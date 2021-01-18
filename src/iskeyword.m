function bol=iskeyword(line)

bol=false;
if length(line)>=2
    if ~strcmp(line(1:2),'**') && strcmp(line(1),'*')
        bol=true;
    end
end
end