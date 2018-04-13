function [dX,dY,dTip,dTilt,dFoc] = missalignment(bench, phaseArray)
	% measure the miss alignment of the mirror
	% measure it from a given phase screen or take a phase screen if not given.  
	% Return 
	% - dX: in m
	% - dY : in m 
	% - dTip : in um rms
	% - dTilt  : in um rms  
	% - dFoc  : un um rms 
    
    if nargin<2    	
    	naomi.configure.mask([]);
    	phaseArray = naomi.measure.phase(bench);
    end
    
	pscale = bench.config.pixelScale;
    diam = bench.config.fullPupillDiameter;
    
	wfs = bench.wfs;

	nSubAperture = bench.nSubAperture;
	x0 = nSubAperture/2;
    y0 = nSubAperture/2;
    
	% Filter pixel with light 
	alight = ~isnan(phaseArray);

	[xArray,yArray] = wfs.meshgrid();
	norm = sum(sum(alight));
	xTarget = sum(sum(alight.*xArray))./norm;
	yTarget = sum(sum(alight.*yArray))./norm;


	[~,PtZ] = naomi.compute.theoriticalZtP(nSubAperture,xTarget,yTarget,diam/pscale,4);
	zer = naomi.compute.nanzero(phaseArray(:)') * reshape(PtZ,[],4);
	
	dX = (xTarget-x0)*pscale;
	dY = (yTarget-x0)*pscale;
	dTip  = zer(2);
	dTilt = zer(3);
	dFoc  = zer(4);	
end