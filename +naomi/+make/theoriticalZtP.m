function [ZtPArray,PtZArray] = theoriticalZtP(bench, mask, maskCenter)
	% Theoretical zernike to phase for the bench 
	nSubAperture = bench.nSubAperture;	
	nZernike = bench.nZernike;
	if nargin<2
		mask = bench.config.ztcMask;
	end
	if nargin<3
		x0 = bench.xCenter;
		y0 = bench.yCenter;
	else
		x0 = maskCenter(1);
		y0 = maskCenter(2);
	end	
	[pupillDiameterPix, centralObscurationPix] = bench.getMaskInPixel(mask);
	
	[ZtPArray,PtZArray] = naomi.compute.theoriticalZtP(nSubAperture,x0,y0,pupillDiameterPix, centralObscurationPix, nZernike);
end