function [ZtPData,PtZData] = ZtP(bench, nPushPull, amplitude, nZernike, callback)
	config = bench.config;
	K = naomi.KEYS;
    
	if nargin<2 || isempty(nPushPull); nPushPull = config.ztpNpushPull; end
	if nargin<3 || isempty(amplitude); amplitude = config.ztpAmplitude; end
	if nargin<4 || isempty(nZernike); nZernike  = config.ztpNzernike; end
	if nargin<5; callback = []; end
	

	if nPushPull<0
		[nZernike,~] = size(bench.ZtCArray);
	end

	nSubAperture = bench.nSubAperture;
	ZtPArray = zeros(nZernike,nSubAperture,nSubAperture);

	bench.log('NOTICE: ZtP Start measure phase for NAOMI modes', 1);
    
    
    
     % setup dm and wfs 
     naomi.action.resetDm(bench);
     naomi.action.resetWfs(bench);
		
    bench.registerProcess('ZtP', nZernike*nPushPull);
		
		% header need to create callbakc phaseZernike
		
    if config.plotVerbose || ~isempty(callback)
        K  = naomi.KEYS;
        phaseData = naomi.data.PhaseZernike([], {});
        if ~isempty(bench.ZtCData)				
            naomi.copyHeaderKeys(bench.ZtCData, phaseData, naomi.ztcKeyList);
            naomi.copyHeaderKeys(bench.ZtCData, phaseData, naomi.ifmKeyList);
        end
        bench.populateHeader(phaseData);
    end
		
	for iZernike=1:nZernike
	    amp = amplitude ./ max(abs(squeeze(bench.ZtCArray(iZernike,':'))));
	    bench.log(sprintf('NOTICE: ZtP Zernike %i',iZernike), 2);  
	    for p=1:nPushPull
            if bench.isProcessKilled('ZtP')
				bench.log(sprintf('NOTICE: ZtP finished before end at %i',iZernike), 1);
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
            if ~isempty(callback)
                % send a phaseZernike to the callback
                phaseData.dataCash = squeeze(ZtPArray(iZernike,:,:));
                phaseData.setKey(K.ZERN,iZernike,K.ZERNc);
                callback(phaseData);
            end
					
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
	    if config.plotVerbose || ~isempty(callback)
             phaseData.dataCash = squeeze(ZtPArray(iZernike,:,:));
             phaseData.setKey(K.ZERN,iZernike,K.ZERNc);
             if ~isempty(callback)
                callback(phaseData);
             end
             if config.plotVerbose
                 naomi.plot.figure('Mode');
                 phaseData.plotAll;
             end 
        end
    end
    bench.killProcess('ZtP');
	
	% Compute the Phase to Naomi matrix (command matrix)
    Tmp = reshape(ZtPArray,nZernike,[]);
    Tmp(isnan(Tmp)) = 0;
    Tmp = pinv(Tmp);
    
    % Set back
    PtZArray = reshape(Tmp,nSubAperture,nSubAperture,nZernike);
    h = {{K.MJDOBS,   config.mjd,     K.MJDOBSc},...
	     {K.NPP  ,    nPushPull,      K.NPPc}, ...
		 {K.PUSHAMP,  amplitude,      K.PUSHAMPc}, ...     
		 {K.NZERN,    nZernike,       K.NZERNc}, ...  
	     {K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
 	     {K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};
    
	ZtPData = naomi.data.ZtP(ZtPArray, h);
    if ~isempty(bench.ZtCData)
        naomi.copyHeaderKeys(bench.ZtCData, ZtPData, naomi.ztcKeyList);
        naomi.copyHeaderKeys(bench.ZtCData, ZtPData, naomi.ifmKeyList);
    end
    bench.populateHeader(ZtPData.header);
	PtZData = naomi.data.PtZ(PtZArray, ZtPData.header);
	bench.log('NOTICE: ZtP Finished', 1);
	
end
