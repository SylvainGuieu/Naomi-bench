function mask = convertMaskUnit(maskIn, unit, pixelScale)
%CONVERTMASK Sconvert the unit of a mask definietion 
%   unit can be 'pixel', 'm' , 'cm' or 'mm'
%   pixelScale is always in m/pixel
v = naomi.convertUnit([maskIn{1}, maskIn{2}], maskIn{3}, unit, pixelScale);
mask = {v(1), v(2), unit};
end

