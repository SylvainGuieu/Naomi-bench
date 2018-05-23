function ZtC = ZtC(IFM, diameter, centralObscurtionDiameter, dmCenterAct, nEigenValue, nZernike)
	% compute.ZtC  Compute the Zernique to command Matrix  
	%
	% ZtC = compute.ZtC(IFM, diameter, dmCenterAct, nEigenValue, nZernike)
	%
	%  The compute.commandMatrix function is used but before, the IF center and 
	% the pixel scale is computed.
	% 
	% IFM(nActuator,nSubAperture,nSubAperture): input Influence Functions
	% dimaeter: pupill diameter in m (should be 28e-3 for NAOMI)
	% centralObscurtion: pupill central obscurtion diameter in (m) (probably 0)
	% dmCenterAct: index of the center actuator
	% nEigenValue: number of accepted Eigenvalues
	% nZerniken : number of zernikes
	IFC = squeeze(IFM(dmCenterAct,:,:));
	[xCenter,yCenter] = naomi.compute.IFCenter(IFC);

    [xS,yS] = naomi.compute.IFMScale(IFM);
    scale = 0.5 * (xS + yS);
    diamPix = diameter / scale;
    centralObscurtionPix = centralObscurtionDiameter / scale;
	[~,ZtC,~] = naomi.compute.commandMatrix(IFM,xCenter,yCenter,diamPix, ...
                                                centralObscurtionPix, ...
                                                nEigenValue, nZernike);
end