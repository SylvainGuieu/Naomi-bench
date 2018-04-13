function [ZtPArray,PtZArray] = theoriticalZtP(bench)
	% Theoretical zernike to phase for the bench 
	nSubAperture = bench.nSubAperture;	
	[nZernike,~] = size(bench.dm.zernike2Command);

	x0 = bench.xCenter;
	y0 = bench.yCenter;
	if isempty(x0); error('The pupill center has not been measured');
	diamPix = bench.sizePix(config.ztcPupillDiameter);
	naomi.compute.theoriticalZtP(nSubAperture,x0,y0,diamPix, nZernike);
end