function bol=iscomment(line)

bol=false;
if length(line)>2
    if strcmp(line(1:2),'**')
        bol=true;
    end
end
end