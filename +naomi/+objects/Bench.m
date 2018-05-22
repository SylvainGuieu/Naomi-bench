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
    simulator; % dm/wavefront simulator  object 
    ACEStatus = false; % true/false if ASE has been started
    subsystems = {'config', 'wfs', 'dm', 'environment', 'gimbal', 'autocol'};
    
    % processes is a containers.Map object. It is used to check if a process
    % is running or not and allows to kill interactively a process
    processes;

    % computed x,y pixel scale as returned by naomi.measure.pixelScale
    % unti is m/pixel
    % the method to get the pixelScale is xPixelScale and yPixelSCale
    measuredXpixelScale;
    measuredYpixelScale;
    
    
    % measured orientation see Config for detailed
    measuredOrientation;
    
    
    % center of dm in pixel unit has returned by naomi.measure.missalignment
    % unit is meters [m]
    dX;
    dY;
    % delta tip and tilt has returned by naomi.measure.missalignment
    % unit are um rms 
    dTip; 
    dTilt;
    dFocus;

    % center of dm in pixel unit. This is the central actuator position 
    % as returned by naomi.measure.IFC
    measuredXcenter;
    measuredYcenter;
    
    % The position of the pupill foot print as measued  by
    % naomi.measure.pupillCenter
    measuredPupillXcenter;
    measuredPupillYcenter;
    
    % the lastPhaseArray recorded by naomi.measure.phase
    lastPhaseArray;
    % incremental counter after each phase measurement 
    phaseCounter = 0;
    % incremental counter after each dm command 
    dmCounter = 0;
    
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

    % the DmBiasData changing it will also changed the bench.dm.biasVector
    dmBiasData;
    
    % the measured or loadded ZtP. this is not need for operation
    ZtPData;

    end
    methods
        function obj = Bench(config)
            if nargin<1
                obj.config = naomi.newConfig();
            else
                obj.config = config;
            end
            obj.processes = containers.Map();
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
            if isempty(varargin)
                if obj.config.isDm
                    obj.start('dm', 'wfs', 'gimbal', 'environment');
                else
                     obj.start('wfs', 'gimbal', 'environment');
                end
               
            else
                for iArg=1:length(varargin)
                    switch varargin{iArg}
                        case 'ace'
                            obj.starACE();
                        case 'dm'
                            obj.startDm();
                        case 'wfs'
                            obj.startWfs();
                        case 'gimbal'
                            obj.startGimbal();
                        case 'environment'
                            obj.startEnvironment();
                        case 'autocol'
                            obj.startAutocol();
                        otherwise
                            error('unknown subsystem %s', varargin{iArg});
                    end
                end
            end
        end
        
        function value = getMeasuredParam(obj, paramName, configName)
            if nargin<2
                value = obj.(paramName);
                if isempty(value)
                    error(sprintf('parameter "%s" has not been measured', paramName));
                end
            else
                value = obj.(paramName);
                if isempty(value)
                    value = obj.config.(configName);
                    if isempty(value)
                        error(sprintf('parameter "%s" has not been measured neither configured', configName));
                    end
                end
            end
        end
        
        function changeDm(obj, dmId)
            % bench.changeDm
            % Change the current dm defined by its Id
            % this will stop the dm environment
            obj.config.dmId = dmId;
            if obj.config.isDm
                obj.stopDm; % stop the dm environment 
            end
            sessionNumber =1;
            while (exist(fullfile(obj.config.todayDirectory, sprintf('%s.%d', dmId, sessionNumber)), 'file'))
                sessionNumber = sessionNumber +1;
            end
            
            obj.config.sessionName = sprintf('%s.%d', dmId, max( 1,sessionNumber-1)); 
        end
        function newSession(obj, name)
            % bench.newSession
            % create a new session. By default this will be the DMID.NUM
            % NUM is the next available number inside the todayDriectory
            % for the given dm
            %
            % optional argument name allows to custom the session name, the 
            % data will be writen in todayDriectory/NAME
            
            if nargin<2
                dmId = obj.config.dmId;
                sessionNumber =1;
                while (exist(fullfile(obj.config.todayDirectory, sprintf('%s.%d', dmId, sessionNumber)), 'file'))
                    sessionNumber = sessionNumber +1;
                end

                obj.config.sessionName = sprintf('%s.%d', dmId, max( 1,sessionNumber));  
            else
                obj.config.sessionName = name;
            end
        end
        function xPixelScale = xPixelScale(obj)
            % measured or configured xPixelScale 
            % use isScaled method to check if the value has been measured
            xPixelScale = obj.getMeasuredParam('measuredXpixelScale', 'xPixelScale');
        end
        
        function yPixelScale = yPixelScale(obj)
            % measured or configured yPixelScale 
            % use isScaled method to check if the value has been measured
            yPixelScale = obj.getMeasuredParam('measuredYpixelScale', 'yPixelScale');
        end
        function meanPixelScale = meanPixelScale(obj)
            meanPixelScale = (obj.xPixelScale + obj.yPixelScale)/2.0;
        end
        function test = isScaled(obj)
            % check if the pixel scale has been measured or not 
            test = ~isempty(obj.measuredXpixelScale);
        end
        
        
        function xCenter = xCenter(obj)
            % measured or configured xCenter 
            % use isCentered method to check if the value has been measured
            xCenter = obj.getMeasuredParam('measuredXcenter', 'xCenter');
        end
        function yCenter = yCenter(obj)
            % measured or configured xCenter 
            % use isCentered method to check if the value has been measured
            yCenter = obj.getMeasuredParam('measuredYcenter', 'yCenter');
        end
        function test = isCentered(obj)
            % check is the centers has been measured 
            test = ~isempty(obj.measuredXcenter);
        end
            
        
        function orientation = orientation(obj)
            % the mirror vs dm orientation has measured or configured
            % use the isOriented method to check if it has been measured
            orientation = obj.getMeasuredParam('measuredOrientation', 'orientation');
        end
        function test = isOriented(obj)
            test = ~isempty(obj.measuredOrientation);
        end
        
        
        function  sizePix = sizePix(obj, sz)
        	%return the size in pixel for a given pupill size in mm
        	% if sz [m] is not given take the default in config.pupillDiameter
        	% if xScale/yScale [m/pixel] has not been computed look at config.pixelScale
            sizePix = sz/obj.meanPixelScale;
        end
    
        function registerProcess(obj, processName, stepSize)
            if nargin<3; stepSize = 0; end
            obj.processes(processName) = {now,0,stepSize};
        end
        function test = isProcessRunning(obj, processName)
            test = ~obj.isProcessKilled(processName);
        end
        function test = isProcessKilled(obj, processName)
           test = true;
           if isKey(obj.processes, processName)
               def = obj.processes(processName);
               test = def{1}<=0.0;
           end
        end
        function processStep(obj, processName, step)
            
            def = obj.processes(processName);
            if nargin<3
               def{2} = def{2}+1;
            else
               def{2} = step;
            end
            obj.processes(processName) = def;
        end
        function status = processStatus(obj, processName)       
            % return a float between 0 to 1 that give the avancement 
            % of the process.
            % In the computation function do the following
            % bench.registerProcess('p1', 10)
            % for i=1:10
            %      bench.processStep('p1', i);
            %      ....
            %
            % Than a graphical interface can do :
            %  bench.processStatus('p1');
            def = obj.processes(processName);
            status = min(def{2}/def{3}, 1.0);
        end
        function killProcess(obj, processName)
            if isKey(obj.processes, processName)
                 def = obj.processes(processName);
                obj.processes(processName) = {-1,def{2},def{3}};
            end
        end
        function test = isAligned(obj)
            % check if the bench has been aligned
            test = ~isempty(obj.measuredXcenter);
        end

        

        function test = isZtPCalibrated(obj)
            % check if the zernike to command is loaded
            test = ~isempty(obj.ZtCData);
        end

        function test = isPhaseReferenced(obj)
            %test  = max(abs(obj.wfs.ref(:)))> 0;
            test = ~isempty(obj.phaseReferenceData);
        end

        function axisName = axisMotor(obj, tip_or_tilt)
            switch tip_or_tilt
                case obj.config.TIP
                    switch obj.config.rXOrder
                        case obj.config.TIP
                            axisName = 'rX';
                        otherwise
                            axisName = 'rY';
                    end
                case obj.config.TILT
                    switch obj.config.rXOrder
                        case  obj.config.TILT
                            axisName = 'rX';
                        otherwise
                            axisName = 'rY';
                    end
                otherwise
                    error(sprintf ('expecting tip or tilt got %s', tip_or_tilt));
            end     
        end
        function mSign = axisSign(obj, tip_or_tilt)
            switch tip_or_tilt
                case obj.config.TIP
                    switch obj.config.rXOrder
                        case obj.config.TIP
                            mSign = obj.config.rXSign;
                        otherwise
                            mSign = obj.config.rYUSign;
                    end
                case obj.config.TILT
                    switch obj.config.rXOrder
                        case  obj.config.TILT
                            mSign = obj.config.rXSign;
                        otherwise
                            mSign = obj.config.rYSign;
                    end
                otherwise
                    error(sprintf ('expecting tip or tilt got %s', tip_or_tilt));
            end     
        end
        function zernikeVector = zernikeVector(obj, varargin)
            if obj.config.simulated
                zernikeVector = obj.simulator.zernikeVector;
            else
                zernikeVector = obj.dm.zernikeVector;
            end
             if ~isempty(varargin);zernikeVector = zernikeVector(varargin{:});end
        end

        function [cmdVector, cmdData] = cmdVector(obj, varargin)
            if obj.config.simulated
                cmdVector = obj.simulator.cmdVector;
            else
                cmdVector = obj.dm.cmdVector;
            end
            if ~isempty(varargin);cmdVector = cmdVector(varargin{:});end
            
            if nargout>1
               h = {};
               cmdData = naomi.data.DmCommand(cmdVector, h, {obj});
               cmdData.biasVector = obj.biasVector;
            end
        end
        function set.ZtCData(obj, ZtCData)
        	obj.config.log('Setting a new Zernique to Command Matrix\n', 1);
            if obj.config.simulated
                obj.simulator.zernike2Command = ZtCData.data;
            else
             if obj.has('dm')
                	obj.dm.zernike2Command = ZtCData.data;
             end
            end
            obj.ZtCData = ZtCData;
        end

        function ZtCArray = ZtCArray(obj, varargin)
            if obj.config.simulated
                ZtCArray = obj.simulator.zernike2Command;
            else
                ZtCArray = obj.dm.zernike2Command;
            end
            if ~isempty(varargin);ZtCArray = ZtCArray(varargin{:});end
        end


        function set.dmBiasData(obj, dmBiasData)
            obj.config.log('Setting a new DM bias\n', 1);
            if obj.config.simulated
                obj.simulator.biasVector = dmBiasData.data(':');
            else
             if obj.has('dm')
                    obj.dm.biasVector = dmBiasData.data(':');
             end
            end
            obj.dmBiasData = dmBiasData;
        end

        function biasVector = biasVector(obj, varargin)
            if obj.config.simulated
                biasVector = obj.simulator.biasVector;
            else
                biasVector = obj.dm.biasVector;
            end
            if ~isempty(varargin);biasVector = biasVector(varargin{:});end
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
        function phaseReferenceArray = phaseReferenceArray(obj, varargin)
            if isempty(obj.phaseReferenceData)
                nSubAperture = obj.nSubAperture;
                phaseReferenceArray = zeros(nSubAperture, nSubAperture);                
            else
                phaseReferenceArray = obj.phaseReferenceData.data;
            end
            if ~isempty(varargin);phaseReferenceArray = phaseReferenceArray(varargin{:});end
        end

        function nSubAperture = nSubAperture(obj)
            
                if obj.has('wfs')
                    nSubAperture = obj.wfs.nSubAperture;
                else
                    nSubAperture = 0;
                end
           
        end

        function nZernike = nZernike(obj)
            if obj.has('dm')
                nZernike = length(obj.zernikeVector);
            else
                nZernike = 0;
            end
        end
        function nActuator = nActuator(obj)
            if obj.has('dm')
                nActuator = length(obj.cmdVector);
            else
                nActuator = 0;
            end
        end


        function maskArray = maskArray(obj, varargin)
            if isempty(obj.maskData)
                nSubAperture = obj.nSubAperture;
                maskArray = ones(nSubAperture, nSubAperture);
            else
                maskArray = obj.maskData.data;
            end
            if ~isempty(varargin)
                maskArray = maskArray(varargin{:});
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
            if obj.config.simulated
                obj.startSimulator();
                obj.wfs = obj.simulator;
            else
                obj.startACE();
                if ~obj.has('wfs'); obj.wfs = naomi.newWfs(obj.config); end
            end
        end
        function stopWfs(obj)
            if obj.config.simulated
                obj.wfs = [];
            else
                obj.wfs = [];
            end
        end
        
       	function startDm(obj)
            if obj.config.simulated
               obj.startSimulator();
               obj.dm = obj.simulator;
            else
                obj.startACE();
                if ~obj.has('dm')
                    obj.dm = naomi.newDm(obj.config); 
                end
            end
        end
        function stopDm(obj)
            if obj.config.simulated
                obj.dm = [];
            else
                obj.dm = [];
            end
        end
        
        function startGimbal(obj)
            if obj.has('gimbal'); return ; end
            
            if obj.config.simulated
                obj.startSimulator();
                obj.gimbal = obj.simulator;
            else
                obj.gimbal = naomi.newGimbal(obj.config); 
            end
        end
        function stopGimbal(obj)
            obj.gimbal = [];
        end
		function startAutocol(obj)
			if ~obj.has('autocol'); obj.autocol = naomi.newAutocol(obj.config); end        	
        end
        function stopAutocol(obj)
            obj.autocol = [];
        end
		function startEnvironment(obj)
            if obj.config.simulated 
                if ~obj.has('environment'); obj.environment= naomi.objects.EnvironmentSimu('simu',1); end
            else
                if ~obj.has('environment'); obj.environment= naomi.newEnvironment(obj.config); end   
            end
        end
        function stopEnvironment(obj)
            if obj.has('environment'); obj.environment.disconnect; end
			obj.environment = [];       	
        end
        function startSimulator(obj)
            if ~obj.has('simulator'); obj.simulator = naomi.newSimulator(obj.config); end  
        end
        function check = checkPhase(obj, phase)
            % Check the integrity of a phase screen
            check = 1;
            maskArray = obj.maskArray;
            if ~all(maskArray(:))
                if any(isnan(phase(maskArray)))
                    check = 0;
                end
            end
        end
        
        
        
        function value = getKey(bench, key, default)
            % define here all the relation between bench parameters and
            % data header keyword
            K = naomi.KEYS;
            switch key 
                case K.WFSNSUB                    
                    value = bench.nSubAperture;
                    
                case K.WFSNAME
                    if bench.has('wfs')
                        value = bench.wfs.model;
                    else
                        value = K.UNKNOWN_STR;
                    end
                    
                case K.ZTCDIAM
                    value = bench.config.ztcPupillDiameter;
                    
                case K.FPUPDIAM
                    value = bench.config.fullPupillDiameter;
                    
                case K.DMID
                    if bench.has('dm')
                        value = bench.dm.sSerialName;
                    else
                        value = bench.config.dmId;
                    end
                case K.TEMP0
                    if bench.has('environment')
                        value = bench.environment.getTemp(0);
                    else
                        value = K.UNKNOWN_FLOAT;
                    end
                case K.TEMP1
                    if bench.has('environment')
                        value = bench.environment.getTemp(1);
                    else
                        value = K.UNKNOWN_FLOAT;
                    end
                
                
                otherwise
                    if nargin<2
                        error('unknown key "%s"', key);
                    else
                        value = default;
                    end
                    
            end
        end
        function test(obj)
            obj.getKey('TEMP1');
        end
        function h = populateHeader(obj, h)
            % populate a generic fits header for all files a maximum of
            % information is populated here
            h = naomi.addToHeader(h, 'TEST', 1, 'THIS IS A TEZT'); 
            return 
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