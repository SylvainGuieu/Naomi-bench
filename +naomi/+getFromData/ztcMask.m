function [mask,maskName] = ztcMask(data, unit)
%MASKFROMDATA return the mask parameters (in pixel) and 
% its center for a data object which have the corresponding ZTC* parameters
% 
if nargin<2; unit = 'pixel'; end
 K = naomi.KEYS;
 maskName = data.getKey(K.ZTCMNAME, K.UNKNOWN);
 pupillDiameterMeter = data.getKey(K.ZTCDIAM); % always stored in meter
 centralObscurtionMeter = data.getKey(K.ZTCOBSDIAM);
 scale = naomi.getFromData.pixelScale(data);
 
 mask = naomi.convertMaskUnit({pupillDiameterMeter, centralObscurtionMeter, 'm'}, unit, scale);
 
end

