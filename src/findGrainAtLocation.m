function grainId = findGrainAtLocation(grains,x,y)

grainId = grains.findByLocation([x,y]);
if isempty(grainId)
    [~,n] = min((grains.x-x).^2+(grains.y-y).^2);
    grainId = grains.findByLocation([grains.x(n),grains.y(n)]);
end
if length(grainId)~=1
    if length(grainId)>1
        grainId = grainId(1);
    elseif length(grainId)<1
        error('Could not find a grain to put here!');
    end
end
end