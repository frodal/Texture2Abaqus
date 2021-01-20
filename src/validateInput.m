function bool = validateInput(nStatev,nDelete,useOneElementPerGrain,grainSize,symX,symY,symZ,shouldGenerateRandomTexture,...
                              shouldGenerateTextureFromOri,shouldGenerateTextureFromXray,shouldGenerateTextureFromEBSD,...
                              flipX,flipY,strechX,strechY,EBSDscanPlane,grainSizeThreshold,confidenseIndexThreshold,grainMisorientationThreshold)

if nStatev<3
    error('nStatev must be 3 or greater');
end
if nDelete<0
    error('nDelete must be 0 or greater');
end
if useOneElementPerGrain~=true && useOneElementPerGrain~=false
    error('useOneElementPerGrain must be true or false')
end
if length(grainSize)~=3
    error('grainSize must contain the grain size in the x, y, and z direction')
end
for i=1:length(grainSize)
    if grainSize(i)<=0
        error('grainSize must be greater than 0')
    end
end
if symX~=true && symX~=false
    error('symX must be true or false')
end
if symY~=true && symY~=false
    error('symY must be true or false')
end
if symZ~=true && symZ~=false
    error('symZ must be true or false')
end
if shouldGenerateRandomTexture~=true && shouldGenerateRandomTexture~=false
    error('shouldGenerateRandomTexture must be true or false')
end
if shouldGenerateTextureFromOri~=true && shouldGenerateTextureFromOri~=false
    error('shouldGenerateTextureFromOri must be true or false')
end
if shouldGenerateTextureFromXray~=true && shouldGenerateTextureFromXray~=false
    error('shouldGenerateTextureFromXray must be true or false')
end
if shouldGenerateTextureFromEBSD~=true && shouldGenerateTextureFromEBSD~=false
    error('shouldGenerateTextureFromEBSD must be true or false')
end
if shouldGenerateRandomTexture+shouldGenerateTextureFromOri+shouldGenerateTextureFromXray+shouldGenerateTextureFromEBSD~=1
    error('One of the texture flags should be true, while the others should be false!')
end
if flipX~=true && flipX~=false
    error('flipX must be true or false')
end
if flipY~=true && flipY~=false
    error('flipY must be true or false')
end
if strechX~=true && strechX~=false
    error('strechX must be true or false')
end
if strechY~=true && strechY~=false
    error('strechY must be true or false')
end
if ~strcmp(EBSDscanPlane,'ED-TD') && ~strcmp(EBSDscanPlane,'ED-ND') && ~strcmp(EBSDscanPlane,'TD-ND')
    error('EBSDscanPlane must be one of: "ED-TD", "ED-ND" or "TD-ND"')
end
if grainSizeThreshold<0
    error('grainSizeThreshold must be 0 or greater');
end
if confidenseIndexThreshold<0
    error('confidenseIndexThreshold must be 0 or greater');
end
if grainMisorientationThreshold<=0
    error('grainMisorientationThreshold must be greater than 0');
end
bool = true;

end