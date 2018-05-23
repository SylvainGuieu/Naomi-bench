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
    
    logBuffer; % initialized at startup 
    productBuffer;
    
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
    measuredXpupillCenter;
    measuredYpupillCenter;
    
    % the lastPhaseArray recorded by naomi.measure.phase
    lastPhaseArray;
    % incremental counter after each phase measurement 
    phaseCounter = 0;
    % incremental counter after each dm command 
    dmCounter = 0;
    
    % The mask data as created by naomi.make.pupillMask 
    maskData;
    % mask can have a name 
    maskName = 'UNKNOWN';

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
            obj.logBuffer = naomi.objects.Buffer(1, 400, 200, 1, 'string');
            obj.productBuffer = naomi.objects.Buffer(1, 50, 20, 1, 'string');
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
            obj.log(sprintf('NOTICE: changing dm from %s to %s',obj.config.dmId, dmId));
            obj.config.dmId = dmId;
            if obj.config.isDm
                obj.stopDm; % stop the dm environment 
                if obj.has('gimbal')
                    obj.stopGimbal; % stop the gimbal mount 
                end
            end
            sessionNumber =1;
            while (exist(fullfile(obj.config.todayDirectory, sprintf('%s.%d', dmId, sessionNumber)), 'file'))
                sessionNumber = sessionNumber +1;
            end
            
            obj.config.sessionName = sprintf('%s.%d', dmId, max( 1,sessionNumber-1)); 
            obj.log(sprintf('NOTICE: dm chenged  to %s',obj.config.dmId));
            obj.log(sprintf('NOTICE: session name is now %s ',obj.config.sessionName));
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
            % this is the position of the central actuator as measured by 
            % naomi.measure.IFC
            % use isCentered method to check if the value has been measured
            xCenter = obj.getMeasuredParam('measuredXcenter', 'xCenter');
        end
        
        function yCenter = yCenter(obj)
            % measured or configured xCenter 
            % this is the position of the central actuator as measured by 
            % naomi.measure.IFC
            % use isCentered method to check if the value has been measured
            yCenter = obj.getMeasuredParam('measuredYcenter', 'yCenter');
        end
        
        function xPupillCenter = xPupillCenter(obj)
            % measured or configured xPupillCenter 
            % This is the center of the pupill as returned by naomi.measure.pupillCenter
            % use isAligned method to check if the value has been measured or is default 
            xPupillCenter = obj.getMeasuredParam('measuredXpupillCenter', 'xPupillCenter');
        end
        
        function yPupillCenter = yPupillCenter(obj)
            % measured or configured yPupillCenter 
            % This is the center of the pupill as returned by naomi.measure.pupillCenter
            % use isAligned method to check if the value has been measured or is default 
            yPupillCenter = obj.getMeasuredParam('measuredYpupillCenter', 'yPupillCenter');
        end
        
        
        
        function test = isCentered(obj)
            % check is the centers has been measured on the DM with the central actuator
            test = ~isempty(obj.measuredXcenter);
        end
        
        function test = isAligned(obj)
            % check if the bench has been aligned (with the trace of pupill on the wfs)
            test = ~isempty(obj.measuredXpupillCenter);
        end
        
        function orientation = orientation(obj)
            % the mirror vs dm orientation has measured or configured
            % use the isOriented method to check if it has been measured
            orientation = obj.getMeasuredParam('measuredOrientation', 'orientation');
        end
        function test = isOriented(obj)
            test = ~isempty(obj.measuredOrientation);
        end
        
        
        function  valuePixel = meter2pixel(obj, valueMeter)
        	%return the size in pixel for a given size in meter
        	% 
        	% if xScale/yScale [m/pixel] has not been computed look at config.pixelScale
            valuePixel = valueMeter/obj.meanPixelScale;
        end
        
        function  valueMeter = pixel2meter(obj, valuePixel)
        	%return the size in meter for a given size inpixel
          valueMeter = valuePixel*obj.meanPixelScale;
        end
        
        function [pupillDiameterPix, centralObscurtionDiameterPix] = getMaskInPixel(bench, mask)
          mask = bench.config.getMask(mask);
          if iscell(mask)
            if length(mask)~=3
              error('Mask must be a string, a 3 cell array or a matrix');
            end
            pupillDiameter = mask{1};
            centralObscurtionDiameter = mask{2};
            unit = mask{3};
            switch unit
              case 'm'
                pupillDiameterPix = bench.meter2pixel(pupillDiameter);
              	centralObscurtionDiameterPix = bench.meter2pixel(centralObscurtionDiameter);
              case 'mm'
                pupillDiameterPix = bench.meter2pixel(pupillDiameter/1000.);
              	centralObscurtionDiameterPix = bench.meter2pixel(centralObscurtionDiameter/1000.);
              case 'cm'
                pupillDiameterPix = bench.meter2pixel(pupillDiameter/100.);
              	centralObscurtionDiameterPix = bench.meter2pixel(centralObscurtionDiameter/100.);
              case 'mum'
                pupillDiameterPix = bench.meter2pixel(pupillDiameter/1e6);
              	centralObscurtionDiameterPix = bench.meter2pixel(centralObscurtionDiameter/1e6);
              case 'pixel'
                pupillDiameterPix = pupillDiameter;
                centralObscurtionDiameterPix = centralObscurtionDiameter;
             
              otherwise
                error('mask unit must be on of m, mm, cm, mum or pixel')
            end   
          else
            pupillDiameterPix = nan;
            centralObscurtionDiameterPix = nan;
          end
        end
        
        
        function [pupillDiameterMeter, centralObscurtionDiameterMeter] = getMaskInMeter(bench, mask)
          mask = bench.config.getMask(mask);
          if iscell(mask)
            if length(mask)~=3
              error('Mask must be a string, a 3 cell array or a matrix');
            end
            pupillDiameter = mask{1};
            centralObscurtionDiameter = mask{2};
            unit = mask{3};
            switch unit
              case 'm'
                pupillDiameterMeter = pupillDiameter;
              	centralObscurtionDiameterMeter = centralObscurtionDiameter;
              case 'mm'
                pupillDiameterMeter = pupillDiameter/1000.;
              	centralObscurtionDiameterMeter = centralObscurtionDiameter/1000.;
              case 'cm'
                pupillDiameterMeter = pupillDiameter/100.;
              	centralObscurtionDiameterMeter = centralObscurtionDiameter/100.;
              case 'mum'
                pupillDiameterMeter = pupillDiameter/1e6;
              	centralObscurtionDiameterMeter = centralObscurtionDiameter/1e6;
              case 'pixel'
                pupillDiameterMeter = bench.pixel2meter(pupillDiameter);
                centralObscurtionDiameterMeter = bench.pixel2meter(centralObscurtionDiameter);
             
              otherwise
                error('mask unit must be on of m, mm, cm, mum or pixel')
            end   
          else
            pupillDiameterMeter = nan;
            centralObscurtionDiameterMeter = nan;
          end
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
        	obj.log('NOTICE: Received a new Zernique to Command Matrix', 2);
             if obj.has('dm')
                	obj.dm.zernike2Command = ZtCData.data;
             end
            obj.ZtCData = ZtCData;
        end
        
        function ZtCArray = ZtCArray(obj, varargin)
            ZtCArray = obj.dm.zernike2Command;
            if ~isempty(varargin);ZtCArray = ZtCArray(varargin{:});end
        end


        function set.dmBiasData(obj, dmBiasData)
            obj.log('NOTICE: Receive a new DM bias', 2);
             if obj.has('dm')
                    obj.dm.biasVector = dmBiasData.data(':');
             end
            obj.dmBiasData = dmBiasData;
        end

        function biasVector = biasVector(obj, varargin)
            biasVector = obj.dm.biasVector;
            if ~isempty(varargin);biasVector = biasVector(varargin{:});end
        end
        
        function set.phaseReferenceData(obj, PR)
        	if isempty(PR)
        		obj.log('NOTICE: Removing the phase reference ', 2);
                if obj.has('wfs'); obj.phaseReferenceData = []; end;
        	else
	        	obj.log('NOTICE: Setting a new Phase Reference', 2);
                obj.phaseReferenceData = PR;
                
	        	if obj.has('wfs');                     
                    %check if it is working 
                    naomi.measure.phase(obj);
            end;	        				
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
        function dmId = dmId(obj)
            if obj.has('dm')
                dmId = obj.dm.sSerialName;
            else
                dmId = obj.config.dmId;
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
           obj.log('NOTICE: Starting WaveFront Sensor...', 1);
            if obj.config.simulated
                obj.startSimulator();
                obj.wfs = obj.simulator;
            else
                obj.startACE();
                if ~obj.has('wfs'); obj.wfs = naomi.newWfs(obj.config); end
            end
            obj.log('NOTICE: WaveFront Started', 1);
        end
        function stopWfs(obj)
          obj.log('NOTICE: Stopping WaveFront Sensor...', 1);
            if obj.config.simulated
                obj.wfs = [];
            else
                obj.wfs = [];
            end
            obj.log('NOTICE: WaveFront Stopped', 1);
        end
        
       	function startDm(obj)
            obj.log('NOTICE: Starting DM ...', 1);
            if obj.config.simulated
               obj.startSimulator();
               obj.dm = obj.simulator;
            else
                obj.startACE();
                if ~obj.has('dm')
                    obj.dm = naomi.newDm(obj.config); 
                end
            end
            if ~obj.has('gimbal')
              
              if obj.config.assignGimbal>=0 % assign the right gimbal number 
                obj.log(sprintf('NOTICE: Gimbal number associated to dm is now %i', obj.config.gimbalNumber), 2);
              end
            end
            obj.log('NOTICE: DM Started', 1);
        end
        function stopDm(obj)
            obj.log('NOTICE: Stopping DM ...', 1);
            if obj.config.simulated
                obj.dm = [];
            else
                obj.dm = [];
            end
            obj.log('NOTICE: DM Stopped', 1);
        end
        
        function startGimbal(obj)
            obj.log('NOTICE: Starting Gimbal ...', 1);
            if obj.has('gimbal'); return ; end
            
            if obj.config.simulated
                obj.startSimulator();
                obj.gimbal = obj.simulator;
            else
                obj.gimbal = naomi.newGimbal(obj.config); 
            end
            obj.log('NOTICE: Gimbal Started', 1);
        end
        function stopGimbal(obj)
            obj.log('NOTICE: Stopping Gimbal ...', 1);
            obj.gimbal = [];
            obj.log('NOTICE: Gimbal Stopped', 1);
        end
		
		function startEnvironment(obj)
            obj.log('NOTICE: Starting Environment ...', 1);
            if obj.config.simulated 
                if ~obj.has('environment'); obj.environment= naomi.objects.EnvironmentSimu('simu',1); end
            else
                if ~obj.has('environment'); obj.environment= naomi.newEnvironment(obj.config); end   
            end
            obj.log('NOTICE: Environment Started', 1);
        end
        function stopEnvironment(obj)
          obj.log('NOTICE: Stopping Environment ...', 1);
          if obj.has('environment'); obj.environment.disconnect; end
			     obj.environment = [];  
          obj.log('NOTICE: Environment Stopped', 1);
        end
        function startSimulator(obj)
            obj.log('NOTICE: Stopping Simulator ...', 1);
            if ~obj.has('simulator'); obj.simulator = naomi.newSimulator(obj.config); end  
            obj.log('NOTICE: Simulator Stopped', 1);
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
        
        function log(obj, txt, verbose)
          % add a log line in the buffer and print it
          date = datestr(now, 'yyyy-mm-ddTHH:MM:SS');
          if nargin<3
            verbose=1;
          end
          if verbose<=obj.config.verbose
            obj.logBuffer.newEntry(string(sprintf('%s %s',date, txt)));
            fprintf('%s %s\n',date, txt);
          end
        end
        
        function logProduct(obj, product)
          % log a newly created product in the buffer
          %   the input string is the product path 
          obj.productBuffer.newEntry(string(product));
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
                    value = bench.getMaskInMeter(bench.config.ztcMask);
                    
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
        
        
        function h = populateHeader(obj, h)
            % populate a generic fits header for all files a maximum of
            % information is populated here
            % catch a maximum of Error to avoid that files writing fail
            if obj.has('wfs');
              try
                obj.wfs.populateHeader(h);
              catch err
                obj.log('WARNING: problem when populating error from wfs')
                disp(getReport(err,'extended'));
              end
            end
            if obj.has('envirnomnet');
              try
                obj.environment.populateHeader(h);
              catch err
                obj.log('WARNING: problem when populating error from environmnent')
                disp(getReport(err,'extended'));
              end
            end
            if obj.has('gimbal');
              try
                obj.gimbal.populateHeader(h);
              catch err
                obj.log('WARNING: problem when populating error from gimbal')
                disp(getReport(err,'extended'));
              end
            end
            
            K = naomi.KEYS;
            
            if obj.has('dm');
              try
                naomi.addToHeader(h, K.DMID, obj.dm.sSerialName, K.DMIDc);
              catch err
                obj.log('WARNING: problem when populating error from dm')
                disp(getReport(err,'extended'));
              end
            end
            
            
            
            if obj.isCentered
               	naomi.addToHeader(h, K.XCENTER, obj.xCenter, K.XCENTERc);
                naomi.addToHeader(h, K.YCENTER, obj.yCenter, K.YCENTERc);
            end
            if obj.isAligned
                naomi.addToHeader(h, K.XPCENTER, obj.x, K.XPCENTERc);
                naomi.addToHeader(h, K.YPCENTER, obj.yCenter, K.YPCENTERc);
            end
            
            if obj.isScaled
                naomi.addToHeader(h, K.XPSCALE, obj.xPixelScale, K.XPSCALEc)
                naomi.addToHeader(h, K.YPSCALE, obj.yPixelScale, K.YPSCALEc)
            end
            naomi.addToHeader(h, K.ORIENT, obj.orientation, K.ORIENTc);
            
        end
    end
end