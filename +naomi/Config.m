classdef Config < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % location where the script has been started
        location = 'IPAG';
        % these will be filled when location is set 
        rootDirectory;
        dataDirectory;
        configDirectory;
        reportDirectory;
        % ACE root directory 
        ACEROOT =  'C:\AlpaoCoreEngine';
        
        dmIDList = {'BAX153','BAX159','BAX199','BAX200', 'BAX201', 'DUMMY'};
        dmID = '';
        % Pupill diameter size in m 
        pupillDiameter = 38e-3;
        
        % Assumed aproximative pixel scale 
        pixelScale = 0.38e-3; % m / pixel
        % The real x and y pixel scale will be computed 
        % if left it to negative value
        xPixelScale = -99.9;
        yPixelScale = -99.9;
        
        % center actuator id number
        dmCenterAct = 121;
        % Real xCenter, yCenter value 
        % left to negative value it will be computed 
        xCenter = -99.9;
        yCenter = -99.9;
        % IFC, Interaction Function for Center actuator is computed
        % IFC should be a Data (contains environment keywords)
        IFC;
        
        % Bench Phase reference file
        % leave '' to ask user 
        phaseReferenceFile = '';
        % put -1 aske user 
        removeReferenceTipTilt = -1;
        
        % computed dm phase reference, must be a Data object
        PHASE_REF;
        
        % number of push pull for DM center computation
        centerNpp = 2;
        % push pull ampliture for DM center computation
        centerAmplitude = 0.15;
        % number of pushPull for wfs pixel scale computation 
        scaleNpp = 1;
        scaleAmplitude = 0.1;
        % number of Pull for phase reference computation
        referenceNp = 1;
        
        % Which order correspond to rX and rY motor movement 
        rXOrder = 2;
        rYOrder = 3;
        % Sign of rX movement regarding to zernic order 
        rXSign = 1;
        rYSign = 1;
        
        gimbalNumber = 1; 
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
        gimbalRxZero = 0.0;
        gimbalRyZero = 0.0; 
        gimbalRxGain = 3300;
        gimbalRyGain = 5000;
        
        % step for the ramp test  
        gimbalRampStep = 0.2e-3; % in mm
        gimbalRampPoints = 20;   % number of measured point for ramp test
        gimbalHomingPoints = 20; % number of measured point for homing test
        % RampStep is a Data 4xgimbalRampPoints array 
        RampStep; 
        
        % Configurqtion specified for IPAG bench 
        % Auto colimatrice 
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
                     {'xPixelScale',    'XPCALE',  'X pixel scale in m/pixel'},
                     {'yPixelScale',    'YPCALE',  'Y pixel scale in m/pixel'},
                     {'dmCenterAct',    'CENTACT', 'DM center actuator number'},
                     {'xCenter',        'XCENTER', 'DM X center [pixel]'}, 
                     {'yCenter',        'YCENTER', 'DM Y center [pixel]'}, 
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
                set(obj, key, value);
            end
            %% this will create the subdirectories
            obj.location = obj.location;
        end
        function set.location(obj, location)
            switch location
                case {obj.IPAG, obj.BENCH}
                    obj.rootDirectory = 'N:\Bench\';
                case obj.ESOHQ
                    obj.rootDirectory = 'C:\Users\NAOMI-IPAG-2\Documents\DM_Testing\';
                otherwise
                    error(sprintf('location should be IPAG, ESO-HQ or Bench got %s',location))
            end
            obj.dataDirectory   = fullfile(obj.rootDirectory,'Data');
            obj.configDirectory = fullfile(obj.rootDirectory,'Config');
            obj.reportDirectory = fullfile(obj.rootDirectory,'Figures');
            obj.location = location;
        end
        function askLocation(obj)
            % ask the location from a dialog box
            l = {char(obj.IPAG), char(obj.BENCH), char(obj.ESOHQ)};
            [loc,~] = listdlg('PromptString','Select Location:','SelectionMode','single','ListString',l);
            obj.location = char(l(loc));
        end
        function dir = todayDirectory(obj);
            dir = fullfile(obj.dataDirectory, datestr(now,'yyyy-mm-dd'));
        end
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
        function askGimbalNumber(obj)
            numbers = {};
            for i=1:length(obj.gimbalsZeros)
                numbers{i} = num2str(obj.gimbalsZeros{i}{1});
            end
            [gid,~] = listdlg('PromptString','Select a gimbal:','SelectionMode','single','ListString',numbers);
            obj.gimbalNumber = str2num(numbers{gid});
        end
        function askDmID(obj)
             % ask the dmId from a dialog box
             [dmID,~] = listdlg('PromptString','Select a DM:','SelectionMode','single','ListString',obj.dmIDList);
             obj.dmID = char(obj.dmIDList(dmID));
        end
        function dmID = getDmID(obj)
            % return DmID or ask 
            if strcmp(obj.dmID, '')
                obj.askDmID()
            end
            dmID = obj.dmID
        end
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
        			obj.dmCenterAct = value;
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


