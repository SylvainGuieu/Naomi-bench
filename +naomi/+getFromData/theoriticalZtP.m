function ZtPArray = theoriticalZtP (data, nZernike)
    
    
    [xCenter, yCenter] = naomi.getFromData.dmCenter(data);
    [mask, ~, ~, ~, ~, orientation] = naomi.getFromData.ztcParameters(data, 'pixel');
    angle = naomi.getFromData.dmAngle(data);
    
    nSubAperture = data.getKey(naomi.KEYS.WFSNSUB, 0);
    if ~nSubAperture
        nSubAperture = data.nSubAperture;
    end
    
    ZtPArray = naomi.compute.theoriticalZtP(...
                     nSubAperture, ...
                     xCenter, ...
                     yCenter, ...
                     mask{1}, ...
                     mask{2}, ...
                     nZernike, ...
                     orientation, angle); 
end