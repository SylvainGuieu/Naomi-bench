classdef Config < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        verbose = 2; % verbose level for NAOMI measurement/action/config ... 
        plotVerbose = true; % standalone plot are ploted or not when doing measurement 

        %% some measure.* function will write the result on the 
        %% the bench object, but only if autoConfig is true
        %% ashould be always true unless for debug purpose
        autoConfig = true;
        % location where the script has been started
        location = 'IPAG';
        % possible loction and their root directory associated
        locationRoots = {
            {'IPAG',   'N:\Bench\'},
            {'Bench',  'N:\Bench\'},
            {'ESO-HQ', 'C:\Users\NAOMI-IPAG-2\Documents\DM_Testing\'}
        }

        % these will be filled when location is set 
        rootDirectory;
        dataDirectory;
        configDirectory;
        reportDirectory;
        % ACE root directory 
        ACEROOT =  'C:\AlpaoCoreEngine';
        
        dmIDChoices = {'BAX153','BAX159','BAX199','BAX200', 'BAX201', 'DUMMY'};
        dmID = '';
        
        % Bench pupill diameter size in m
        % this is the physical pupill of the DM on the bench 
        % not the one used for ZtC (see bellow)  
        pupillDiameter = 36.5e-3;
         
        
        % some typical mode to compute the ZtC 
        %           |- config mode for Zernique2Command computation
        %           |               |- diameter used for ZtC
        %           |               |        |- Neig value 
        %           |               |        |   |- Nzern number of Zernique to keep 
        ztcDef = {
                  {'naomi',        28.0e-3, 140, 100},
                  {'naomi-sparta', 28.0e-3, 140, 21 }, 
                  {'bench',        36.5e-3, 220, 100}
                };
        % current ztcMode 
        ztcMode = 'naomi';
        % ZtC pupill size used for computation in m 
        ztcPupillDiameter = 28.0e-3;
        % number of Neig for Zernique to command matrix 
        ztcNeig = 140;
        % number of Zernique to command matrix 
        ztcNzer = 100;


        % Assumed aproximative pixel scale for start-up alignment
        pixelScale = 0.38e-3; % m / pixel
        
        
        % center actuator id number
        dmCentralActuator = 121;       
        
        % Bench Phase reference file
        % leave '' to ask user when using getPhaseReferenceFile
        phaseReferenceFile = '';

        % 1/0 put -1 force to ask user with getRemoveReferenceTipTilt
        removeReferenceTipTilt = -1;
        
        %default number of phase average 
        defaultNp = 1;

        % number of Np for phase refernence
        phaseRefNp = 2;


        % number of push pull for DM center computation
        centerNpp = 2;
        % push pull ampliture for DM center computation
        centerAmplitude = 0.15;
        % number of pushPull for wfs pixel scale computation 
        scaleNpp = 1;
        scaleAmplitude = 0.1;
        % number of Pull for phase reference computation
        referenceNp = 1;
        

        % define usable IF/IFM parameters 
        ifDef = {
                       % |- ifNpp
                       % |  |- ifAMplitude 
                       % |  |     |- ifmNloop
                       % |  |     |  |- ifmPause 
            {'quick',    1, 0.3,  1, 0.0},
            {'accurate', 2, 0.35, 2, 1.0}
            
        };
        ifMode = 'quick';

        %%
        % The 4 following parameters will be modified 
        % when ifMode is changed
        % default Npp for IF and IFM computation 
        ifNpp = 1;
        % default Amplitude for IF and IFM computation 
        ifAmplitude = 0.3;
        % default number of llop for IFM computation 
        ifmNloop = 1;
        % default pause (in sec) between actuator for IFM 
        ifmPause = 0.0;

        %%
        % IFM cleaning parameter 
        ifmCleanPercentil = 50;
        
        
        %%%%%%%%%%%%%%%%%%%%%
        % startup alignment  
        %%%%%%%%%%%%%%%%%%%%%

        % the pupill centering accuracy must be in m 
        pupillCenteringThreshold =  0.05e-3;

        % the tip/tilt centering accuracy must be in um rms 
        % for manual centering 
        pupillTipTiltThresholdManual = 1;
        % for automatic centering (gimbal motors)
        pupillTipTiltThresholdAuto = 0.1;
        
        
        %%%%%%%%%%%%%%%%%%%%%
        % gimbal movement specification 
        %%%%%%%%%%%%%%%%%%%%%

        % Which order correspond to rX and rY motor movement 
        rXOrder = 2; %tip
        rYOrder = 3; %tilt
        % Sign of rX movement regarding to zernic order 
        rXSign = 1;
        rYSign = 1;
        
        % set gimbalNumber to negative value will force to ask user  
        gimbalNumber = -9; 
        % dictionary of rx, ry gimbal zero position and gain 
        %                |-serial number
        %                | |- rX zero position 
        %                | |    |- rY zero position  
        %                | |    |     |- rX gain in arcsec/mm  
        %                | |    |     |     |- rY gain in arcsec/mm
        gimbalsDef =   {{1,14.5,15.7, 3300, 5000}, 
                        {2,14.5,15.7, 3300, 5000},
                        {3,14.5,15.7, 3300, 5000},
                        {4,14.5,15.7, 3300, 5000}
                       };
        % these parameters are modified when the gimbalNumber is set 
        gimbalRxZero = 14.5;
        gimbalRyZero = 15.7; 
        gimbalRxGain = 3300;
        gimbalRyGain = 5000;
        
        % step for the ramp test  
        gimbalRampStep = 0.2e-3; % in mm
        gimbalRampPoints = 20;   % number of measured point for ramp test
        gimbalHomingPoints = 20; % number of measured point for homing test
        

        % Configuration specified for IPAG bench 
        % Auto colimatrice port communication 
        autocolCom = 'com1';
        
        % some constant
        IPAG = 'IPAG';
        ESOHQ = 'ESO-HQ';
        BENCH = 'Bench';
        DUMMY = 'DUMMY';
        
        
        % define the properties / FITS key / fits comment used by writeFits Header
        propDef = {
                     {'location',       'ORIGIN',  'Where data has been taken IPAG/ESO-HQ/BENCH'},
                     {'mjd',            'MJD-OBS', 'Modified Julian Date of writing header'},
                     {'dateobs',        'DATE-OBS','Date of writing header'},
                     {'dmID',           'DM-ID' ,  'DM identification'},
                     {'pupillDiameter', 'PUPDIAM', 'Pupill Diamter [m]'},                    
                     {'dmCentralActuator',    'CENTACT', 'DM center actuator number'},                     
                     {'centerNpp',      'CTNPP',   'Number of push/pull for IFC computation'},
                     {'centerAmplitude','CTAMP',   'push/pull amplitude for IFC computation'}, 
                     {'scaleNpp',       'SCNPP',   'Number of push/pull for scale computation'}, 
                     {'scaleAmplitude', 'SCAMP',   'push/pull amplitude for scale computation'}, 
                     {'referenceNp',    'RFNP',    'Number of push for flat/reference measurement'},
                     {'rXOrder',        'RXORDER', 'Zernike order or rx motor movement'},
                     {'rYOrder',        'RYORDER', 'Zernike order or ry motor movement'},
                     {'rXSign',         'RXSIGN',  'Zernike sign or rx positive motor movement'},
                     {'rYSign',         'RYSIGN',  'Zernike sign or ry positive motor movement'}
            };
    end
    
    methods
        function obj = Config(varargin)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            if mod(nargin,2)
                error(sprintf('naomiConfig takes a number of odd key/value arguments got %d',nargin));
            end
            for i = 1:nargin:2
                key = varargin{i};
                value = varargin{i+1};
                setfield(obj, key, value);
            end
            %% this will create the subdirectories
            obj.location = obj.location;
        end

        function log(obj, str, level)
            if nargin<3
                level = obj.verbose;
            end
            naomi.log(str, level, obj.verbose);
        end
        function set.location(obj, location)
            found = false
            for iLoc=1:length(obj.locationRoots)
                if strcmp(location, obj.locationRoots{iLoc}{1})
                    obj.rootDirectory = obj.locationRoots{iLoc}{2};
                    found = true;
                end
            end
            if ~found;
                error(strcat('unknown location ', location));
            end
            obj.dataDirectory   = fullfile(obj.rootDirectory,'Data');
            obj.configDirectory = fullfile(obj.rootDirectory,'Config');
            obj.reportDirectory = fullfile(obj.rootDirectory,'Figures');
            obj.location = location;
        end

        function locations = locationChoices(obj)
            locations = {}
            for iLoc=1:length(obj.locationRoots)
                locations{iLoc} = obj.locationRoots{iLoc}{1};
            end
        end
        function askLocation(obj)
            % ask the location from a dialog box             
            [loc,~] = listdlg('PromptString','Select Location:','SelectionMode','single','ListString',obj.locationChoices);
            obj.location = char(l(loc));
        end
        function location = getLocation(obj)
            if obj.location; location = obj.location; 
            else location = obj.askLocation(); end
        end        
        function dir = todayDirectory(obj);
            dir = fullfile(obj.dataDirectory, datestr(now,'yyyy-mm-dd'));
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   IF mode set/ask/get/choices function 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set.ifMode(obj,mode)
            found = false;
            for i=1:length(obj.ifDef)
                def = obj.ifDef{i};
                if strcomp(mode,def{1})
                    obj.ifNpp = def{2};
                    obj.ifAmplitude = def{3};
                    obj.ifmNloop = def{4};
                    obj.ifmPause = def{5};
                    found = true;
                end
            end
            if ~found: error(strcat('unknown mode ',mode)); end 

            obj.ifMode = mode; 
        end 
        function ifModes = ifModeChoices(obj)
            ifModes = {};
            for i=1:length(obj.ifDef)
                ifModes{i} = num2str(obj.ifDef{i}{1});
            end
        end
        function askIfMode(obj)
            ifModes = obj.ifModeChoices;
            [gid,~] = listdlg('PromptString','Select IFM measurement mode:','SelectionMode','single','ListString',obj.ifModes);
            obj.ifMode = str2num(ifModes{gid});
        end
        function ifMode = getIfMode(obj)
            % return IfMode or ask 
            if strcmp(obj.ifMode, '')
                obj.askIfMode()
            end
            ifMode = obj.ifMode
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   ztc mode set/ask/get/choices function 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function set.ztcMode(obj,mode)
            found = false;
            for i=1:length(obj.ztcDef)
                def = obj.ztcDef{i};
                if strcomp(mode,def{1})
                    obj.ztcPupillDiameter = def{2};
                    obj.ztcNeig = def{3};
                    obj.ztcNzer = def{4};
                    found = true;
                end
            end
            if ~found: error(strcat('unknown mode ',mode)); end 

            obj.ztcMode = mode; 
        end 
        function ztcModes = ztcModeChoices(obj)
            ztcModes = {};
            for i=1:length(obj.ztcDef)
                ztcModes{i} = num2str(obj.ztcDef{i}{1});
            end
        end
        function askZtcMode(obj)
            ztcModes = obj.ztcModeChoices;
            [gid,~] = listdlg('PromptString','Select ztcM measurement mode:','SelectionMode','single','ListString',obj.ztcModes);
            obj.ztcMode = str2num(ztcModes{gid});
        end
        function ztcMode = getZ2cMode(obj)
            % return IfMode or ask 
            if strcmp(obj.ztcMode, '')
                obj.askZtcMode()
            end
            ztcMode = obj.ztcMode
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   gimbal number set/ask/get/choices function 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function set.gimbalNumber(obj,num)
            for i=1:length(obj.gimbalsDef)
                def = obj.gimbalsDef{i};
                if num==def{1}
                    obj.gimbalRxZero = def{2};
                    obj.gimbalRyZero = def{3};
                    obj.gimbalRxGain = def{4};
                    obj.gimbalRyGain = def{5};
                end
            end
            obj.gimbalNumber = num; 
        end 
        function numbers = gimbalNumberChoices(obj)
            numbers = {};
            for i=1:length(obj.gimbalsDef)
                numbers{i} = num2str(obj.gimbalsDef{i}{1});
            end
        end
        function askGimbalNumber(obj)
            numbers = obj.gimbalNumberChoices;
            [gid,~] = listdlg('PromptString','Select a gimbal:','SelectionMode','single','ListString',numbers);
            obj.gimbalNumber = str2num(numbers{gid});
        end
        function gimbalNumber = getGimbalNumber(obj)
            % return gimbalNumber or ask 
            if obj.gimbalNumber<0
                obj.askGimbalNumber()
            end
            gimbalNumber = obj.gimbalNumber
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   dmID set/ask/get/choices function 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        function askDmID(obj)
             % ask the dmId from a dialog box
             dmIds = obj.dmIDChoices;
             [iDmID,~] = listdlg('PromptString','Select a DM:','SelectionMode','single','ListString',dmIds);
             obj.dmID = char(dmIds(iDmID));
        end
        function dmID = getDmID(obj)
            % return DmID or ask 
            if strcmp(obj.dmID, '')
                obj.askDmID()
            end
            dmID = obj.dmID
        end

        

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   phaseReferenceFile 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function askPhaseReferenceFile(obj)
           prompt = {'Load a recent REF_DUMMY reference of the bench (or let empty)'};
           answer = inputdlg(prompt,'Bench reference',[1 80],{obj.phaseReferenceFile});
           if ~isempty(answer) && ~strcmp(answer(1),'')
               obj.phaseReferenceFile = char(answer);
           elseif isempty(answer)
               % nothing to do 
           else 
               obj.phaseReferenceFile = '';
           end
        end

        function phaseReferenceFile = getPhaseReferenceFile(obj)
            if strcmp(obj.phaseReferenceFile, '')
                obj.askPhaseReferenceFile;
            end
            phaseReferenceFile = obj.phaseReferenceFile;
        end


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   remove reference tiptill 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function askRemoveReferenceTipTilt(obj)
            choice = questdlg({'Do you want to remove','the mean Tip/Tilt from WFS?'}, ...
	                          'Phase reference', 'Yes', 'No','Yes');
           obj.removeReferenceTipTilt = strcmp(choice,'Yes');
        end


        function removeReferenceTipTilt = getRemoveReferenceTipTilt(obj)
            if obj.removeReferenceTipTilt<0
                obj.askRemoveReferenceTipTilt
            end
            removeReferenceTipTilt = obj.removeReferenceTipTilt;
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %  
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                

        function mjd = mjd(obj)
            % modified julian date
            mjd = juliandate(datetime('now'),'modifiedjuliandate');
        end
        function dateobs = dateobs(obj)
            dateobs = datestr(now,'yyyy-mm-ddThh:MM:SS');
        end



        function populateHeader(obj, f)
            % populate a generic fits header for all files a maximum of
            % information is populated here
            
            for i=1:length(obj.propDef)
                def = obj.propDef{i};
                naomi.addToHeader(f, def{2}, obj.(def{1}), def{3});
            end
        end

        function loadFitsHeader(obj,f)
            % not used to be remove at some point. 
            % the idea was to modify the config from a fits file header
            % but they are to many cases and variable to make it work 
            % corectly.
        	keyCells = f.keywords; % to be defined
        	for i=1:length(keyCells)
        		c = keyCells{i};
        		key = c{1};
        		value = c{2};
        		switch key
        		case 'ORIGIN'
        			obj.location = value;
        		case 'DM-ID'
        			obj.dmId = value;
        		case 'PUPDIAM'
        			obj.pupillDiameter = value;
        		case 'XPCALE'
        			obj.xPixelScale = value;
        		case 'YPCALE'
        			obj.yPixelScale = value;
        		case 'CENTACT'
        			obj.dmCentralActuator = value;
        		case 'XCENTER'
        			obj.xCenter = value;
        		case 'YCENTER'
        			obj.yCenter = value;
        		case 'CTNPP'
					obj.centerNpp = value;
				case 'CTAMP'
					obj.centerAmplitude = value;
				case 'SCNPP'
					obj.scaleNpp = value;
				case 'SCAMP'
					obj.scaleAmplitude = value;
				case 'RFNP'
					obj.referenceNp = value;
				case 'RXORDER'
					obj.rXOrder = value;
				case 'RYORDER'
					obj.rYOrder = value;
				case 'RXSIGN'
					obj.rXSign = value;
				case 'RYSIGN'
					obj.rYSign = value;
                end
            end
        end
    end
end


