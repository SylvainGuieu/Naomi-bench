function [ZtP,PtZ] = ZtP(bench, Npp, amplitude, Nzern)
	global stopZtPMeasurement
	stopZtPMeasurement = false;

	config = bench.config;
	wfs = bench.wfs;
	dm = bench.dm;

	if nargin<2; Npp = config.ztpNpp; end;
	if nargin<3; amplitude = config.ztpAmplitude; end;
	if nargin<4; Nzern = config.ztpNzern; end; 

	if Npp<0
		[Nzer,~] = size(dm.zernike2Command);
	end

	Nsub = wfs.Nsub;
	ZtPArray = zeros(Nzer,Nsub,Nsub);

	config.log('Measure phase for NAOMI modes\n', 1);

	h = {{'MJD-OBS', config.mjd, 'MJD when measure script started'},
	     {'ZTP_NPP',  Npp, 'Number of push-pull'}, 
		 {'ZTP_AMP', amplitude,  '[Cmax] amplitude of push-pull'}, 
		 {'ZTP_NZER', amplitude,  'number of zerniques'},
		 };
		 
	ZtP = naomi.data.ZtP(ZtPArray, h, {bench});

	% setup dm and wfs 
	dm.Reset();
	wfs.Reset();
	

	for z=1:Nzer
		if stopZtPMeasurement
			Ztp = [];
			PtZ = [];
			return ;
		end

	    amp = amplitude ./ max(abs(squeeze(dm.zernike2Command(z,:))));
	    config.log(sprintf(' %i',z), 1);  
	    for p=1:Npp
	    	% take the zerniqueVector reference
	        ref = dm.zernikeVector(z);
	        dm.zernikeVector(z) = ref + amp;
	        if config.plotVerbose; dm.DrawMonitoring; end;
	        push = naomi.measure.phase(bench,1).data;
	        
	        dm.zernikeVector(z) = ref - amp;
	        if config.plotVerbose; dm.DrawMonitoring; end;
	        pull = naomi.measure.phase(bench,1).data;
	        ZtPArray(z,:,:) = ZtPArray(z,:,:) + reshape((push - pull)/(2*amp*Npp),1,Nsub,Nsub);
	        % put back the zernique vector as it was
	        dm.zernikeVector(z) = ref;
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
    Tmp = reshape(ZtPArray,Nzer,[]);
    Tmp(isnan(Tmp)) = 0;
    Tmp = pinv(Tmp);
    
    % Set back
    PtZArray = reshape(Tmp,Nsub,Nsub,Nzer);
	
	PtZ = naomi.data.PtZ(PtZArray, h, {bench}); 

end
