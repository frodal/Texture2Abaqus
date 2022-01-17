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
function bool = validateInput(nStatev,nDelete,useOneElementPerGrain,grainSize,symX,symY,symZ,shouldGenerateRandomTexture,...
                              shouldGenerateTextureFromOri,shouldGenerateTextureFromXray,shouldGenerateTextureFromEBSD,shouldGenerateTextureFromMTEXODF,...
                              flipX,flipY,strechX,strechY,EBSDscanPlane,grainSizeThreshold,confidenseIndexThreshold,grainMisorientationThreshold,...
                              shouldUseFCTaylorHomogenization,nTaylorGrainsPerIntegrationPoint)

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
if shouldGenerateTextureFromMTEXODF~=true && shouldGenerateTextureFromMTEXODF~=false
    error('shouldGenerateTextureFromMTEXODF must be true or false')
end
if shouldGenerateRandomTexture+shouldGenerateTextureFromOri+shouldGenerateTextureFromXray+shouldGenerateTextureFromEBSD+shouldGenerateTextureFromMTEXODF~=1
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
if nTaylorGrainsPerIntegrationPoint<1
    error('nTaylorGrainsPerIntegrationPoint must be 1 or greater');
end
if shouldUseFCTaylorHomogenization~=true && shouldUseFCTaylorHomogenization~=false
    error('shouldUseFCTaylorHomogenization must be true or false')
end
if shouldUseFCTaylorHomogenization==true && shouldGenerateTextureFromEBSD==true
    error('Can not use the Taylor homogenization approach with an EBSD map!')
end
bool = true;

end