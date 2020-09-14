function bol=iskey(line,key)

bol=false;
l=length(key);

if length(line)>=l
    if strcmp(line(1:l),key)
        bol=true;
    end
end
end