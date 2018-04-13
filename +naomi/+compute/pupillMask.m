function maskArray = pupillMask(nSubAperture,diameterPix,centralObscurtionPix, xCenterPix, yCenterPix)
	% build a mask array 
	% -nSubAperture number of sub pupill in both direction 
	% -diameterPix :  mask outer diameter in pixel
	% -centralObscurtionPix: mask inner diamter in pixel
	% -xCenterPix, yCenterPix: position of the mask in pixel
	[Y,X] = meshgrid(1:nSubAperture,1:nSubAperture);
    Z = (X-xCenterPix).^2 + (Y-yCenterPix).^2 < (diameterPix*diameterPix/4);
    Z = Z .* ((X-xCenterPix).^2 + (Y-yCenterPix).^2 >= (diameterPix*diameterPix*centralObscurtionPix*centralObscurtionPix/4));
    maskArray = ones(nSubAperture,nSubAperture);
    maskArray(~Z) = NaN;
end
