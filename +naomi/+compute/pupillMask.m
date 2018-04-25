function maskArray = pupillMask(nSubAperture,diameterPix,centralObscurtionPix, xCenterPix, yCenterPix)
	% build a mask array 
	% -nSubAperture number of sub pupill in both direction 
	% -diameterPix :  mask outer diameter in pixel
	% -centralObscurtionPix: mask inner diamter in pixel
	% -xCenterPix, yCenterPix: position of the mask in pixel
	[X,Y] = meshgrid(1:nSubAperture,1:nSubAperture);
    Z = (X-xCenterPix).^2 + (Y-yCenterPix).^2 < (diameterPix*diameterPix/4);
    if centralObscurtionPix>0
        Z = Z .* ((X-xCenterPix).^2 + (Y-yCenterPix).^2 >= (centralObscurtionPix*centralObscurtionPix/4));
    end
    maskArray = ones(nSubAperture,nSubAperture, 'logical');
    maskArray(~Z) = 0;
end
