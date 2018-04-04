classdef Bench < naomi.objects.BaseObject
    %  Bench object contain all the subsystem of naomi calibration bench 
    %  this is the unique interface for all the measurement function.

    properties
    config; % configuration object all the configuration goes here 
    wfs; % wavefront sensor object 
    dm;  % dm object 
    environment;
    gimbal; % gimabal object 
    autocol; % autocolimatrice object (only at IPAG calibration bench) 
    ACEStatus = false; % true/false if ASE has been started
    subsystems = {'config', 'wfs', 'dm', 'environment', 'gimbal', 'autocol'};


    % computed x,y pixel scale as returned by naomi.measure.pixelScale
    % unti is m/pixel
    xPixelScale;
    yPixelScale;

    % center of dm in pixel unit has returned by naomi.measure.missalignment
    % unit is meters [m]
    dX;
    dY;
    % delta tip and tilt has returned by naomi.measure.missalignment
    % unit are um rms 
    dTip; 
    dTilt;
    dFocus;

    % center of dm in pixel unit has returned by naomi.measure.IFC
    % unit is in pixel 
    xCenter;
    yCenter;

    % PHASE_REF
    % the phase Reference data, this should be a naomi.data.PhaseReference object 
    % and represent the bench static aberation (taken with a dummy) and should not
    % contain Tip and Tilt or Piston  
    PHASE_REF;

    % The IF computed for the center actuator as returned by naomi.measure.IFC
    % this should be a naomi.data.IF object
    IFC;

    % The IFM and IFMClean as returned by naomi.measure.IFM
    IFM;
    IFMClean;
    ZtC; % changing the ZtC will change the dm.zernike2Command

    end
    methods
        function obj = Bench(varargin)
        	obj.config = naomi.Config();
        	obj.start(varargin{:});
        end

        function test = has(obj, name)
        	% check if the subsystem of name 'name' is ready
        	% exemple  
        	% if bench.has('wfs') & bench.has('dm')
        	% 	dosomething();
        	% end
        	test = ~isempty(obj.(name));
        end

        function start(obj, varargin)
        	for iArg=1:length(varargin)
        		switch varargin{iArg}
        		case 'dm'
        			obj.startDm();
        		case 'wfs'
        			obj.startWfs();
        		case 'gimbal'
        			obj.startGimbal();
        		case 'environmnet'
        			obj.startEnvironment();
        		case 'autocol'
        			obj.startAutocol();
        		otherwise
        			error(strcat('unknown subsystem ', varargin{iArg}));
                end
            end
        end

        function  sizePix = sizePix(obj, sz)
        	%return the size in pixel for a given pupill size in mm
        	% if sz [m] is not given take the default in config.pupillDiameter
        	% if xScale/yScale [m/pixel] has not been computed look at config.pixelScale

        	if isempty(obj.xScale)
        		obj.config.log('Warning asking for pixel scale, but it was not measured. Default pixelScale is returned\n', 2);
        		scale = obj.config.pixelScale;
        	else
        		scale = 0.5 * (obj.xScale + obj.yScale);
        	end        	
        	if nargin<2; sz = obj.config.pupillDiameter; end
        	sizePix = sz/scale;
        end

        function set.ZtC(obj, ZtC)
        	obj.config.log('Setting a new Zernique to Command Matrix\n', 1);
        	obj.dm.zernike2Command = ZtC.data;
        end

        function set.PHASE_REF(obj, PR)
        	if isempty(PR)
        		obj.config.log('Removing the phase reference ...', 1);
        		obj.wfs.resetReference();
        	else
	        	obj.config.log('Setting a new Phase Reference ...', 1);
	        	obj.wfs.ref = PR.data;  
	        	%check if it is working 
				obj.wfs.getPhase();      	
				obj.config.log('OK\n', 1);
			end
        end

        function startACE(obj)
        	if ~obj.ACEStatus
        		obj.ACEStatus = naomi.startACE(obj.config);
        	end
        end
        function startWfs(obj)
        	obj.startACE();
        	if ~obj.has('wfs'); obj.wfs = naomi.startWfs(obj.config); end
      	end
       	function startDm(obj)
       		obj.startACE();
        	if ~obj.has('dm'); obj.dm = naomi.startDm(obj.config); end
       	end
        function startGimbal(obj)
			if ~obj.has('gimbal'); obj.gimbal = naomi.startGimbal(obj.config); end        	
		end
		function startAutocol(obj)
			if ~obj.has('autocol'); obj.autocol = naomi.startAutocol(obj.config); end        	
		end
		function startEnvironment(obj)
			if ~obj.has('environment'); obj.environment= naomi.startEnvironment(obj.config); end        	
		end

        function populateHeader(obj, h)
            % populate a generic fits header for all files a maximum of
            % information is populated here
           	
           	for iSys=1:length(obj.subsystems)
           		s = obj.subsystems{iSys};
           		if obj.has(s); obj.(s).populateHeader(h); end
            end
        end
    end
end