function [ZtP,PtZ] = ZtP(bench, nPushPull, amplitude, nZernike)
	global stopZtPMeasurement
	stopZtPMeasurement = false;

	config = bench.config;
	
	if nargin<2; nPushPull = config.ztpNpushPull; end;
	if nargin<3; amplitude = config.ztpAmplitude; end;
	if nargin<4; nZernike  = config.ztpNzernike; end; 

	if nPushPull<0
		[nZernike,~] = size(bench.ZtCArray);
	end

	nSubAperture = bench.nSubAperture;
	ZtPArray = zeros(nZernike,nSubAperture,nSubAperture);

	config.log('Measure phase for NAOMI modes\n', 1);

	h = {{'MJD-OBS', config.mjd, 'MJD when measure script started'},
	     {'ZTP_NPP',  nPushPull, 'Number of push-pull'}, 
		 {'ZTP_AMP', amplitude,  '[Cmax] amplitude of push-pull'}, 
		 {'ZTP_NZER', nZernike,  'number of zernikes'},		 
		 };
		 
	ZtP = naomi.data.ZtP(ZtPArray, h, {bench});

	% setup dm and wfs 
	naomi.action.resetDm(bench);
	naomi.action.resetWfs(bench);
		

	for z=1:nZernike
		if stopZtPMeasurement
			Ztp = [];
			PtZ = [];
			return ;
		end

	    amp = amplitude ./ max(abs(squeeze(benc.ZtPArray()(z,:))));
	    config.log(sprintf(' %i',z), 1);  
	    for p=1:nPushPull
	    	% take the zernikeVector reference
	        ref = bench.zernikeVector()(z);
	        naomi.action.cmdModal(bench, z, ref + amp);	        
 	        push = naomi.measure.phase(bench,1);
	        
	        naomi.action.cmdModal(bench, z, ref - amp);	 	        
	        pull = naomi.measure.phase(bench,1);
	        ZtPArray(z,:,:) = ZtPArray(z,:,:) + reshape((push - pull)/(2*amp*nPushPull),1,nSubAperture,nSubAperture);
	        % put back the zernike vector as it was

	        naomi.action.cmdModal(bench, z, ref);
	    end   
	    
	    % Cleanup piston
	    ZtPArray(z,:,:) = ztPArray(z,:,:) - naomi.compute.nanmean(reshape(ZtPArray(z,:,:),[],1));
	    if z==1
	        ZtPArray(1,:,:) = ZtPArray(1,:,:) + 1.0;
	    end
	    
	    % Plot
	    if config.plotVerbose
		    bench.config.figure('Mode');
		    ZtP.plotOneMode(z);	   
		end
	end
	config.log('\n', 1); 
	% Compute the Phase to Naomi matrix (command matrix)
    Tmp = reshape(ZtPArray,nZernike,[]);
    Tmp(isnan(Tmp)) = 0;
    Tmp = pinv(Tmp);
    
    % Set back
    PtZArray = reshape(Tmp,nSubAperture,nSubAperture,nZernike);
	
	PtZ = naomi.data.PtZ(PtZArray, h, {bench}); 

end
