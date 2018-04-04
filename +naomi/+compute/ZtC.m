function ZtC = ZtC(IFM, diameter, dmCenterAct, Neig, Nzer)
	% compute.ZtC  Compute the Zernique to command Matrix  
	%
	% ZtC = compute.ZtC(IFM, diameter, dmCenterAct, Neig, Nzer)
	%
	%  The compute.cmdMat function is used but before, the IF center and 
	% the pixel scale is computed.
	% 
	% IFM(Nact,Nsub,Nsub): input Influence Functions
	% dimaeter: pupill diameter in m (should be 28e-3 for NAOMI)
	% dmCenterAct: index of the center actuator
	% Neig: number of accepted Eigenvalues
	% Nzern : number of zerniques
	IFC = squeeze(IFM(dmCenterAct,:,:));
	[xCenter,yCenter] = naomi.compute.IFCenter(IFC);

    [xS,yS] = naomi.compute.IFMScale(IFM);
    scale = 0.5 * (xS + yS);
    diamPix = diameter / scale;

	[~,ZtC,~] = naomi.compute.cmdMat(IFM,xCenter,yCenter,diamPix,Neig,Nzer,1);
end