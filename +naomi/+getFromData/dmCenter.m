function [xCenter, yCenter] = dmCenter(data, unit)
    
    K = naomi.KEYS;
    xCenter = data.getKey(K.XCENTER, []);
    if isempty(xCenter)
        warning('Could not found centering information in data header assuming this is half of the number of sub aperture');
        nSubAperture = data.getKey(K.WFSNSUB);
        % X/YOFFSET is not written in header but can be set by user to play
        % with the data 
        xCenter = nSubAperture/2 + data.getKey(K.XOFFSET, 0.0);
        yCenter = nSubAperture/2 + data.getKey(K.YOFFSET, 0.0);
    else
        xCenter = xCenter + data.getKey(K.XOFFSET, 0.0);
        yCenter = data.getKey(K.YCENTER)+ data.getKey(K.YOFFSET, 0.0);
    end
    
    if nargin>1
        xy = naomi.convertUnit([xCenter,yCenter], 'pixe', unit, naomi.getFromData.pixelScale(data));
        xCenter = xy(1);
        yCenter = xy(2);
    end
    
end