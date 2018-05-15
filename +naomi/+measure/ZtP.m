function [ZtPData,PtZData] = ZtP(bench, nPushPull, amplitude, nZernike)
	config = bench.config;
	K = naomi.KEYS;
    
	if nargin<2; nPushPull = config.ztpNpushPull; end
	if nargin<3; amplitude = config.ztpAmplitude; end
	if nargin<4; nZernike  = config.ztpNzernike; end

	if nPushPull<0
		[nZernike,~] = size(bench.ZtCArray);
	end

	nSubAperture = bench.nSubAperture;
	ZtPArray = zeros(nZernike,nSubAperture,nSubAperture);

	config.log('Measure phase for NAOMI modes\n', 1);
    if ~isempty(bench.ZtCData)
        pupillDiameter = bench.ZtCData.getKey(K.ZTCDIAM, 0);
        if pupillDiameter ==0 % assume this is the configured pupill diameter
            pupillDiameter = bench.config.ztcPupillDiameter;
        end
        
    else % assume this is the configured pupill diameter
        pupillDiameter = bench.config.ztcPupillDiameter;
    end
    xPscale =  bench.xPixelScale;
    yPscale =  bench.yPixelScale;
    
    xCenter = bench.xCenter;
    yCenter = bench.yCenter;
    
	% setup dm and wfs 
	naomi.action.resetDm(bench);
	naomi.action.resetWfs(bench);
		
    bench.registerProcess('ZtP', nZernike*nPushPull);
	for iZernike=1:nZernike
		

	    amp = amplitude ./ max(abs(squeeze(bench.ZtCArray(iZernike,':'))));
	    config.log(sprintf(' %i',iZernike), 1);  
	    for p=1:nPushPull
            if bench.isProcessKilled('ZtP')
                ZtPData =[];
                PtZData = [];
                return 
            end
            
	    	% take the zernikeVector reference
	        ref = bench.zernikeVector(iZernike);
	        naomi.action.cmdModal(bench, iZernike, ref + amp);	        
 	        push = naomi.measure.phase(bench,1);
	        
	        naomi.action.cmdModal(bench, iZernike, ref - amp);	 	        
	        pull = naomi.measure.phase(bench,1);
	        ZtPArray(iZernike,:,:) = ZtPArray(iZernike,:,:) + reshape((push - pull)/(2*amp*nPushPull),1,nSubAperture,nSubAperture);
	        % put back the zernike vector as it was
	        naomi.action.cmdModal(bench, iZernike, ref);
            bench.processStep('ZtP', p*iZernike);
	    end   
	    
	    % Cleanup piston
	    ZtPArray(iZernike,:,:) = ...
            ZtPArray(iZernike,:,:) - ...
            naomi.compute.nanmean(reshape(ZtPArray(iZernike,:,:),[],1));
        
	    if iZernike==1
	        ZtPArray(1,:,:) = ZtPArray(1,:,:) + 1.0;
	    end
	    
	    % Plot
	    if config.plotVerbose
		    naomi.plot.figure('Mode');
            phaseData = naomi.data.PhaseZernike(squeeze(ZtPArray(iZernike, :, :)), {{naomi.KEYS.ZERN, iZernike, naomi.KEYS.ZERNc}});
            phaseData.plotAll();   
		end
    end
    bench.killProcess('ZtP');
	config.log('\n', 1); 
	% Compute the Phase to Naomi matrix (command matrix)
    Tmp = reshape(ZtPArray,nZernike,[]);
    Tmp(isnan(Tmp)) = 0;
    Tmp = pinv(Tmp);
    
    % Set back
    PtZArray = reshape(Tmp,nSubAperture,nSubAperture,nZernike);
    h = {{K.MJDOBS,   config.mjd,    K.MJDOBSc},...
	     {K.NPP  ,    nPushPull,     K.NPPc}, ...
		 {K.PUSHAMP,  amplitude,     K.PUSHAMPc}, ...     
		 {K.NZERN,    nZernike,       K.NZERNc}, ...  
         {K.ZTCDIAM,  pupillDiameter, K.ZTCDIAMc}, ...
         {K.XPSCALE,  xPscale,        K.XPSCALEc}, ...
         {K.YPSCALE,  yPscale,        K.YPSCALEc}, ...
         {K.XCENTER,  xCenter,        K.XCENTERc}, ...
         {K.YCENTER,  yCenter,        K.YCENTERc}
		 };
    
	ZtPData = naomi.data.ZtP(ZtPArray, h, {bench});
	PtZData = naomi.data.PtZ(PtZArray, h, {bench}); 

end
