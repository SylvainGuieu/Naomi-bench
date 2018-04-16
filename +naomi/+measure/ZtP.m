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
    if ~isempty(bench.ZtCData)
        pupillDiameter = bench.ZtCData.getKey('DIAM', 0);
        if pupillDiameter ==0 % assume this is the configured pupill diameter
            pupillDiameter = bench.config.ztcPupillDiameter;
        end
    else % assume this is the configured pupill diameter
        pupillDiameter = bench.config.ztcPupillDiameter;
    end
	h = {{'MJD-OBS', config.mjd, 'MJD when measure script started'},
	     {'ZTPNPP',  nPushPull, 'Number of push-pull'}, 
		 {'ZTPAMP', amplitude,  '[Cmax] amplitude of push-pull'}, 
		 {'ZTPNZER', nZernike,  'number of zernikes'},
         {'ZTPDIAM', pupillDiameter,'Pupill diameter in[m]'}, 
         {'ZTPDIAMP',bench.sizePix(pupillDiameter) ,'Pupill diameter in  wfs pixel'}      
		 };
		 
	ZtP = naomi.data.ZtP(ZtPArray, h, {bench});

	% setup dm and wfs 
	naomi.action.resetDm(bench);
	naomi.action.resetWfs(bench);
		

	for iZernike=1:nZernike
		if stopZtPMeasurement
			Ztp = [];
			PtZ = [];
			return ;
		end

	    amp = amplitude ./ max(abs(squeeze(bench.ZtPArray()(iZernike,:))));
	    config.log(sprintf(' %i',z), 1);  
	    for p=1:nPushPull
	    	% take the zernikeVector reference
	        ref = bench.zernikeVector()(iZernike);
	        naomi.action.cmdModal(bench, iZernike, ref + amp);	        
 	        push = naomi.measure.phase(bench,1);
	        
	        naomi.action.cmdModal(bench, iZernike, ref - amp);	 	        
	        pull = naomi.measure.phase(bench,1);
	        ZtPArray(iZernike,:,:) = ZtPArray(iZernike,:,:) + reshape((push - pull)/(2*amp*nPushPull),1,nSubAperture,nSubAperture);
	        % put back the zernike vector as it was

	        naomi.action.cmdModal(bench, iZernike, ref);
	    end   
	    
	    % Cleanup piston
	    ZtPArray(iZernike,:,:) = ...
            ztPArray(iZernike,:,:) - ...
            naomi.compute.nanmean(reshape(ZtPArray(iZernike,:,:),[],1));
        
	    if iZernike==1
	        ZtPArray(1,:,:) = ZtPArray(1,:,:) + 1.0;
	    end
	    
	    % Plot
	    if config.plotVerbose
		    bench.config.figure('Mode');
		    ZtP.plotOneMode(iZernike);	   
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
