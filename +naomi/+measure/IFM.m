function [IFMData, IFMcleanData] = IFM(bench, varargin) %callback, nPushPull, nLoop, amplitude, ifmPause)
%   measure.IFM  Get the Influence Function of all actuators 
% 
%   IFM = measure.IFM(bench, nPushPull, nLoop, amplitude, ifmPause)
%
%   The requested actuator is push-pulled and the difference
%   is returned as its influence function. The amplitude is reversed
%   between each loop (to reverse creep).
% 
%   bench: naomi bench structure including wfs and dm object
%   callback : a call back function called after each push pull measurement
%              the call back is receiving a naomi.data.IF object
%   nPushPull: number of push-pull
%   nLoop: Number of loop across actuator (recommended 2)
%   amplitude: amplitude of the push-pull
%   ifmPause: pause before starting next actuator
% 
%   IFMData : the influence functions data object
%   IFMCleanData : the cleaned influence functions object   
% 
	config = bench.config;
	mjd =  config.mjd;
    
    P = naomi.parseParameters(varargin, {'nPushPull', 'nLoop', 'amplitude', 'ifmPause', 'callback', 'mode', 'dateOb', 'tplName'}, 'measure.IFM');
    
    callback = naomi.getParameter([], P, 'callback', 'ifmCallback', []);
    
    mode = naomi.getParameter([], P, 'mode', 'ifmMode', []);
    if isempty(mode)
        % get the default or user parameters
        nPushPull = naomi.getParameter(bench, P, 'nPushPull', 'ifmNpushPull');
        amplitude = naomi.getParameter(bench, P, 'amplitude', 'ifmAmplitude');
        nLoop   = naomi.getParameter(bench, P, 'nLoop', 'ifmNloop');
        ifmPause = naomi.getParameter(bench, P, 'ifmPause', 'ifmPause');
    else
        % retrieve the parameter for this mode 
        [nPushPull, amplitude, nLoop, ifmPause] = bench.config.ifmParameters(mode);
        % overwrite parameter of this mode from user, if any
         nPushPull = naomi.getParameter([], P, 'nPushPull', 'ifmNpushPull', nPushPull);
         amplitude = naomi.getParameter([], P, 'amplitude', 'ifmAmplitude', amplitude);
         nLoop     = naomi.getParameter([], P, 'nLoop', 'ifmNloop', nLoop);
         ifmPause  = naomi.getParameter([], P, 'ifmPause', 'ifmPause', ifmPause); 
    end
    
    P.nPushPull = nPushPull;
    P.Amplitude = amplitude;
    
	nActuator = bench.nActuator;
	nSubAperture = bench.nSubAperture;
	IFM = zeros(nActuator,nSubAperture,nSubAperture);

	% Loop
    bench.registerProcess('IFM', nLoop*nActuator);
    
    naomi.action.resetDm(bench);
    naomi.config.mask(bench, []); % remove the mask
    start = now;
	environmentBuffer = naomi.objects.EnvironmentBuffer(nLoop*nActuator, nLoop*nActuator, 0);
		
	bench.log(sprintf('NOTICE: Starting IFM measurement for DM %s', bench.dmId),1);
	for iLoop=1:nLoop
	    
	    % Loop on actuators
	    for iActuator=1:nActuator
            if bench.isProcessKilled('IFM')
                % the process has been killed 
                IFMData = [];
                IFMcleanData = [];
				bench.log(sprintf('WARNING: IFM measurement of DM %s killed before finished', bench.dmId), 1); 
                return
            end
            if (iActuator*iLoop)>1
                remainingTime = (now-start)*24*3600 / (iActuator*iLoop) * (nActuator*nLoop-iActuator*iLoop);
                bench.log(sprintf('NOTICE: IFM Loop=%d/%d Actuator=%d/%d Time=%0.3fs remainingTime=%0.3fs', iLoop, nLoop, iActuator, nActuator, (now-start)*24*3600, remainingTime),2);
                
            else
                bench.log(sprintf('NOTICE: IFM Loop=%d/%d Actuator=%d/%d Time=%0.3fs', iLoop, nLoop, iActuator, nActuator, (now-start)*24*3600),2);
            end		
            
           IFArray = naomi.measure.IF(bench, iActuator, P);
            
            
            if ~isempty(callback)
                IFData = naomi.data.IF(IFArray, {{naomi.KEYS.ACTNUM,iActuator,naomi.KEYS.ACTNUMc}});
                callback(IFData);
            end
	        
	        	IFM(iActuator,:,:) = IFM(iActuator,:,:) + reshape(IFArray,1,nSubAperture,nSubAperture) / nLoop;
						
	        	pause(ifmPause);
                if bench.has('environment')
                    environmentBuffer.update(bench.environment);
                end
            bench.processStep('IFM', iLoop*iActuator);
						        
	    end
	    
	    % Reverse amplitude (push-pull -> pull-push)
	    amplitude = -amplitude;
    end
    bench.killProcess('IFM');
		bench.log(sprintf('NOTICE: IFM measurement for DM %s finished', bench.dmId),1);
        K = naomi.KEYS;
		dateOb = naomi.getParameter([], P, 'dateOb', [], now);
        tplName = naomi.getParameter([], P, 'tplName', [], K.TPLNAMEd);
		
		h = {{K.MJDOBS ,mjd, K.MJDOBSc},  ...
             {K.DATEOB, dateOb, K.DATEOBc}, ...
             {K.TPLNAME, tplName, K.TPLNAMEc}, ...
		   	 {K.IFAMP  , amplitude, K.IFAMPc }, ...
	     	 {K.IFNPP  , nPushPull, K.IFNPPc }, ...
	     	 {K.IFMLOOP, nLoop, K.IFMLOOPc }, ...
	     	 {K.IFMPAUSE,ifmPause,K.IFMPAUSEc}, ... 
			 {K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
			 {K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};

	IFMData = naomi.data.IFM(IFM, h);
	bench.populateHeader(IFMData.header);
    if bench.has('environment')
        IFMData.environmentData = environmentBuffer.toEnvironmentData;
    end
	
	IFMcleanData = naomi.make.cleanIFM(bench, IFMData);
  bench.killProcess('IFM');
end