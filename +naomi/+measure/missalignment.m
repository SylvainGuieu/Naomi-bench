function [dX,dY,dTip,dTilt,dFoc] = missalignment(bench, phi)
	% measure the miss alignment of the mirror
	% measure it from a given phase screen or take a phase screen if not given.  
	% Return 
	% - dX: in m
	% - dY : in m 
	% - dTip : in um rms
	% - dTilt  : in um rms  
	% - dFoc  : un um rms 

	pscale = bench.config.pixelScale;
	wfs = bench.wfs;

	x0 = wfs.Nsub/2;
    y0 = wfs.Nsub/2;
    if nargin < 2
		phi =  wfs.getPhase();
	end
	% Filter pixel with light 
	alight = ~isnan(phi);

	[X,Y] = wfs.meshgrid();
	norm = sum(sum(alight));
	xTarget = sum(sum(alight.*X))./norm;
	yTarget = sum(sum(alight.*Y))./norm;


	[~,PtZ] = naomi.compute.theoriticalZtP(wfs.Nsub,xTarget,yTarget,diam/pscale,3);
	zer = naomi.nanzero(phi(:)') * reshape(PtZ,[],3);
	
	dx = (xTarget-x0)*pscale;
	dy = (yTarget-x0)*pscale;
	dTip  = zer(2);
	dTilt = zer(3);
	dFoc  = zer(4);	
end