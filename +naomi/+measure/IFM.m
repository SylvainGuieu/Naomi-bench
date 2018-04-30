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
    
    if nargin<2; callback = [];end
    
	if nargin<3; nPushPull = config.ifNpushPull; end
	if nargin<4; nLoop = config.ifmNloop; end
	if nargin<5; amplitude   = config.ifAmplitude; end
	if nargin<6; ifPause  = config.ifmPause; end

	nActuator = bench.nActuator;
	nSubAperture = bench.nSubAperture;
	IFMatrix = zeros(nActuator,nSubAperture,nSubAperture);

	% Loop
    bench.registerProcess('IFM', nLoop*nActuator);
    
    naomi.action.resetDm(bench);
    naomi.config.mask(bench, []); % remove the mask
    
	for iLoop=1:nLoop
	    
	    % Loop on actuators
	    for iActuator=1:nActuator
            if bench.isProcessKilled('IFM')
                % the process has been killed 
                IFMData = [];
                IFMcleanData = [];
                return
            end
            
            IFData = naomi.measure.IF(bench, iActuator, nPushPull, amplitude);
            if ~isempty(callback)
                callback(IFData);
            end
	        IFarray = IFData.data;
	        IFMatrix(iActuator,:,:) = IFMatrix(iActuator,:,:) + reshape(IFarray,1,nSubAperture,nSubAperture) / nLoop;
	        pause(ifPause);
            bench.processStep('IFM', iLoop*iActuator);
                
	    end
	    
	    % Reverse amplitude (push-pull -> pull-push)
	    amplitude = -amplitude;
    end
    bench.killProcess('IFM');
	h = {{'MJD-OBS' ,mjd, 'modified julian when script started'},
		 {'IF_AMP'  ,amplitude,'[Cmax] amplitude of push-pull'},
	     {'IF_NPP'  ,nPushPull,'number of push-pull'},
	     {'IF_LOOP' ,nLoop,'number of push-pull'},
	     {'IF_PAUSE',ifPause,'pause between actioneu'}};

	IFMData = naomi.data.IFMatrix(IFMatrix, h , {bench});
	IFMcleanData = naomi.make.cleanIFM(bench, IFMData);
    bench.killProcess('IFM');
end