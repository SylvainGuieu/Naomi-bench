function [mask,maskName,  xCenter, yCenter] = ztcMaskFromData(data, unit)
%MASKFROMDATA return the mask parameters (in pixel) and 
% its center for a data object which have the corresponding ZTC* parameters
% 
if nargin<2; unit = 'pixel'; end
 K = naomi.KEYS;
 maskName = data.getKey(K.ZTCMNAME, K.UNKNOWN);
 pupillDiameterMeter = data.getKey(K.ZTCDIAM); % always stored in meter
 centralObscurtionMeter = data.getKey(K.ZTCOBSDIAM);
 xCenter = data.getKey(K.ZTCXCENTER);
 yCenter = data.getKey(K.ZTCYCENTER);
 xScale =  data.getKey(K.ZTCXSCALE);
 yScale =  data.getKey(K.ZTCYSCALE);
 scale = 0.5*(xScale+yScale);
 switch unit
     case 'pixel'
        pupillDiameter = pupillDiameterMeter / scale;
        centralObscurtion = centralObscurtionMeter / scale;
     case 'm'
         pupillDiameter = pupillDiameterMeter;
        centralObscurtion = centralObscurtionMeter;
     case 'mm'
         pupillDiameter = pupillDiameterMeter*1000;
        centralObscurtion = centralObscurtionMeter*1000;
     case 'cm'
         pupillDiameter = pupillDiameterMeter*100;
        centralObscurtion = centralObscurtionMeter*100;
     otherwise
         error('invalid unit expecting pixel, m, cm, or mm got %s',unit)
 end
 mask = {pupillDiameter, centralObscurtion, unit};
 
end

