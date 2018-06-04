function theoreticalPhaseArray = theoriticalPhase(data, zernike)
[xCenter, yCenter] = naomi.getFromData.dmCenter(data);
[mask, ~, ~, ~, ~, orientation] = naomi.getFromData.ztcParameters(data, 'pixel');
angle = naomi.getFromData.dmAngle(data);

nSubAperture = data.getKey(naomi.KEYS.WFSNSUB, 0);
if ~nSubAperture
    nSubAperture = data.nSubAperture;
end

theoreticalPhaseArray = naomi.compute.theoriticalPhase(nSubAperture,...
                                                xCenter, yCenter,...
                                                mask{1}, mask{2},...
                                                zernike, ...
                                                orientation, angle);
end