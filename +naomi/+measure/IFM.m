function [IFMData, IFMcleanData] = IFM(bench, callback, nPushPull, nLoop, amplitude, ifPause)
%   measure.IFM  Get the Influence Function of all actuators 
% 
%   IFM = measure.IFM(bench, nPushPull, nLoop, amplitude, ifPause)
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
%   ifPause: pause before starting next actuator
% 
%   IFMData : the influence functions data object
%   IFMCleanData : the cleaned influence functions object   
% 
	config = bench.config;
	mjd =  config.mjd;
    
  if nargin<2; callback = []; end
    
	if nargin<3; nPushPull = config.ifNpushPull; end
	if nargin<4; nLoop = config.ifmNloop; end
	if nargin<5; amplitude   = config.ifAmplitude; end
	if nargin<6; ifPause  = config.ifmPause; end

	nActuator = bench.nActuator;
	nSubAperture = bench.nSubAperture;
	IFM = zeros(nActuator,nSubAperture,nSubAperture);

	% Loop
    bench.registerProcess('IFM', nLoop*nActuator);
    
    naomi.action.resetDm(bench);
    naomi.config.mask(bench, []); % remove the mask
    start = now;
		environmentBuffer = naomi.object.EnvironmentBuffer(nLoop*nActuator, nLoop*nActuator, 0);
		
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
						bench.log(sprintf('NOTICE: IFM Loop=%d/%d Actuator=%d/%d', iLoop, nLoop, iActuator, nActuator),2);
						
            if isempty(callback)
                IFArray = naomi.measure.IF(bench, iActuator, nPushPull, amplitude);
            else
                [IFArray, IFData] = naomi.measure.IF(bench, iActuator, nPushPull, amplitude);
            end
            
            if ~isempty(callback)
                callback(IFData);
            end
	        
	        	IFM(iActuator,:,:) = IFM(iActuator,:,:) + reshape(IFArray,1,nSubAperture,nSubAperture) / nLoop;
						
	        	pause(ifPause);
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
		h = {{K.MJDOBS ,mjd, K.MJDOBSc},  ...
		   	{K.IFAMP  ,amplitude, K.IFAMPc }, ...
	     	{K.IFNPP  ,nPushPull, K.IFNPPc }, ...
	     	{K.IFMLOOP , nLoop, K.IFMLOOPc }, ...
	     	{K.IFMPAUSE,ifPause,K.IFMPAUSEc}, ... 
				{K.PHASEREF, bench.isPhaseReferenced, K.PHASEREFc}, ... 
				{K.PHASETT,  bench.config.filterTipTilt, K.PHASETTc}};

	IFMData = naomi.data.IFM(IFM, h);
	bench.populateHeader(IFMData.header);
	IFMData.environmentData = environmentBuffer.toEnvironmentData;
	
	IFMcleanData = naomi.make.cleanIFM(bench, IFMData);
  bench.killProcess('IFM');
end