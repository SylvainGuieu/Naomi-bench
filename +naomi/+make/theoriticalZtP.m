function [ZtPArray,PtZArray] = theoriticalZtP(bench, mask, maskCenter, nZernike)
	% Theoretical zernike to phase for the bench 
	nSubAperture = bench.nSubAperture;	
	
	if nargin<2 || isempty(mask)
		mask = bench.config.ztcMask;
	end
	if nargin<3 || isempty(maskCenter)
		x0 = bench.xCenter;
		y0 = bench.yCenter;
	else
		x0 = maskCenter(1);
		y0 = maskCenter(2);
    end	
    if nargin<4 || isempty(nZernike)
        nZernike = bench.nZernike;
    end
    
	[pupillDiameterPix, centralObscurationPix] = bench.getMaskInPixel(mask);
	[ZtPArray,PtZArray] = naomi.compute.theoriticalZtP(nSubAperture,x0,y0,pupillDiameterPix, centralObscurationPix, nZernike);
end