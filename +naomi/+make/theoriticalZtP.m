function [ZtPArray,PtZArray] = theoriticalZtP(bench)
	% Theoretical zernike to phase for the bench 
	nSubAperture = bench.nSubAperture;	
	nZernike = bench.nZernike;

	x0 = bench.xCenter;
	y0 = bench.yCenter;
	[pupillDiameterPix, centralObscurationPix] = bench.getMaskInPixel(bench.config.ztcMask);
	
	
	[ZtPArray,PtZArray] = naomi.compute.theoriticalZtP(nSubAperture,x0,y0,pupillDiameterPix, centralObscurationPix, nZernike);
end