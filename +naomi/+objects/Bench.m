classdef Bench < naomi.objects.BaseObject
    %  Bench object contain all the subsystem of naomi calibration bench 
    %  this is the uniue interface for all the measurement function.

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


    % the lastPhaseArray recorded by naomi.measure.phase
    lastPhaseArray;

    % flag for tiptilt removal 
    filterTipTilt = false;
    % flag true will remove the phase reference (if any stored) 
    % to the measured phased by naomi.measure.phase
    substractReference = true;

    % The mask data as created by naomi.make.pupillMask 
    maskData; 

    % phaseReferenceData
    % the phase Reference data, this should be a naomi.data.PhaseReference object 
    % and represent the bench static aberation (taken with a dummy) and should not
    % contain Tip and Tilt or Piston  
    phaseReferenceData;
    
    % The IF computed for the center actuator as returned by naomi.measure.IFC
    % this should be a naomi.data.IF object
    IFCData;

    % The IFMData as returned by naomi.measure.IFM should be the cleaned one 
    % the IFM is only need to compute the ZtC matrix but for DM use
    % the loadding of an IFMData is not necessary if a ZtCData exists
    IFMData;

    % The Zernike 2 command matrix as returned by naomi.make.ZtC
    % changing the ZtCData will change the dm.zernike2Command
    ZtCData;

    % the DM biasData changing it will also changed the dm.biasVector
    biasData;

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

        function test = isAligned(obj)
            % check if the bench has been aligned
            test = ~isempty(obj.xCenter);
        end

        function test = isScaled(obj)
            % check if the pixel scale has been measured 
            test = ~isempty(obj.xPixelScale);
        end

        function test = isZtPCalibrated(obj)
            % check if the zernike to command is loaded
            test = ~isempty(obj.ZtCData);
        end

        function test = isPhaseReferenced(obj)
            test  = max(abs(obj.wfs.ref(:)))> 0;
        end

        function zernikeVector = zernikeVector(obj)
            if obj.config.simulated
                zernikeVector = obj.simulator.zernikeVector;
            else
                zernikeVector = obj.dm.zernikeVector;
            end
        end

        function cmdVector = cmdVector(obj)
            if obj.config.simulated
                cmdVector = obj.simulator.cmdVector;
            else
                cmdVector = obj.dm.cmdVector;
            end
        end
        function set.ZtCData(obj, ZtCData)
        	obj.config.log('Setting a new Zernique to Command Matrix\n', 1);
            if obj.simulated
                obj.simulator.zernike2Command = ZtCData.data;
            else
             if obj.has('dm')
                	obj.dm.zernike2Command = ZtCData.data;
             end
            end
            obj.ZtCData = ZtCData;
        end

        function ZtCArray = ZtCArray(obj)
            if obj.simulated
                ZtCArray = obj.simulator.zernike2Command;
            else
                ZtCArray = obj.dm.zernike2Command;
            end
        end


        function set.biasData(obj, biasData)
            obj.config.log('Setting a new DM bias\n', 1);
            if obj.simulated
                obj.simulator.biasVector = biasData.data;
            else
             if obj.has('dm')
                    obj.dm.biasVector = biasData.data;
             end
            end
            obj.biasData = biasData;
        end

        function biasVector = biasVector(obj)
            if obj.simulated
                biasVector = obj.simulator.biasVector;
            else
                biasVector = obj.dm.biasVector;
            end
        end

        function set.phaseReferenceData(obj, PR)
        	if isempty(PR)
        		obj.config.log('Removing the phase reference ...', 1);
                if obj.has('wfs'); obj.phaseReferenceData = []; end;
        	else
	        	obj.config.log('Setting a new Phase Reference ...', 1);
                obj.phaseReferenceData = PR;

	        	if obj.has('wfs');                     
                    %check if it is working 
                    naomi.measure.phase(obj);
                end;	        					   	
				obj.config.log('OK\n', 1);
            end
            
        end
        function phaseReferenceArray = phaseReferenceArray(obj)
            if isempty(obj.phaseReferenceData)
                nSubAperture = obj.nSubAperture;
                phaseReferenceArray = zeros(nSubAperture, nSubAperture);                
            else
                phaseReferenceArray = obj.phaseReferenceData.data;
            end
        end

        function nSubAperture = nSubAperture(obj)
            if obj.config.simulated
                nSubAperture = obj.simulator.nSubAperture;
            else
                nSubAperture = obj.wfs.nSubAperture;
            end
        end

        function nZernike = nZernike(obj)
            [nZernike] = size(obj.zernikeVector);
        end
        function nActuator = nActuator(obj)
            [nActuator] = size(obj.cmdVector);
        end


        function maskArray = maskArray(obj)
            if isempty(obj.maskData)
                nSubAperture = obj.nSubAperture;
                maskArray = ones(nSubAperture, nSubAperture);
            else
                maskArray = obj.maskData.data;
            end
        end

        function set.maskData(obj, maskData)
            obj.maskData = maskData;
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
        	if ~obj.has('dm'); 
                obj.dm = naomi.startDm(obj.config); 
            end
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

        function check = checkPhase(obj, phase)
            % Check the integrity of a phase screen
            check = 1;
            maskArray = obj.maskArray;
            if ~all(maskArray(:) == 1)
                if any(isnan(phase(maskArray==1)))
                    check = 0;
                end
            end
        end

        function populateHeader(obj, h)
            % populate a generic fits header for all files a maximum of
            % information is populated here

            if isempty(obj.phaseReferenceData)
              naomi.addToHeader(h, 'PHASEREF', 'NO', 'YES/NO subtracted reference');
            else
              naomi.addToHeader(h, 'PHASEREF', 'YES', 'YES/NO subtracted reference');
            end           

            if obj.isAligned
               	naomi.addToHeader(h, obj.xCenter, 'XCENTER', 'X position of pupill [pix]');
                naomi.addToHeader(h, obj.yCenter, 'YCENTER', 'Y position of pupill [pix]');
            end
            if obj.isScaled
                naomi.addToHeader(h, obj.xPixelScale, 'XPSCALE', 'X pixel scale [m/pix]');
                naomi.addToHeader(h, obj.yPixelScale, 'YPSCALE', 'X pixel scale [m/pix]');
            end
           	for iSys=1:length(obj.subsystems)
           		s = obj.subsystems{iSys};
           		if obj.has(s); obj.(s).populateHeader(h); end
            end
        end
    end
end