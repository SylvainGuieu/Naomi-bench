function [ZtPArray,PtZArray] = theoriticalZtP(bench)
	% Theoretical zernique to phase for the bench 
	Nsub = bench.wfs.Nsub;	
	[Nzer,~] = size(bench.dm.zernike2Command);

	x0 = bench.xCenter;
	y0 = bench.yCenter;
	if isempty(x0); error('The pupill center has not been measured');
	diamPix = bench.sizePix(config.ztcPupillDiameter);
	naomi.compute.theoriticalZtP(Nsub,x0,y0,diamPix, Nzer);
end