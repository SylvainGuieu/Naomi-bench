function [ZtPArray,PtZArray] = theoriticalZtP(bench)
	% Theoretical zernike to phase for the bench 
	nSubAperture = bench.nSubAperture;	
	nZernike = bench.nZernike;

	x0 = bench.xCenter;
	y0 = bench.yCenter;
	diamPix = bench.sizePix(bench.config.ztcPupillDiameter);
	[ZtPArray,PtZArray] = naomi.compute.theoriticalZtP(nSubAperture,x0,y0,diamPix, nZernike);
end