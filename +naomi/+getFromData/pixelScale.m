function pixelScale = pixelScale(data) 
    K = naomi.KEYS;
    xScale = data.getKey(K.XPSCALE);
    yScale = data.getKey(K.YPSCALE);
    % PIXSCALEFACTOR  is not writen in the header but could have been set by user 
    % to play with data
    pixelScale = 0.5 * (xScale+yScale) * data.getKey(K.PIXSCALEFACTOR,1.0);
end