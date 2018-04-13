classdef Config < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        verbose = 2; % verbose level for NAOMI measurement/action/config ... 
        plotVerbose = true; % standalone plot are ploted or not when doing measurement 
        % turn on of the simulator 
        simulated = false;
        % software version. This is writen in the fits files to eventualy check one
        % day for uncompatibilities 
        naomiVersion = '01-04-2018';
        
        % location where the script has been started
        location = 'IPAG';
        % possible loction and their root directory associated
        locationRoots = {
            {'IPAG',   'N:\Bench\'},
            {'Bench',  'N:\Bench\'},
            {'ESO-HQ', 'C:\Users\NAOMI-IPAG-2\Documents\DM_Testing\'}
        }

        % tplName as writen in data header products 'TPL_NAME'
        tplName = 'TEST';

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
        fullPupillDiameter = 36.5e-3;
         
        
        % some typical mode to compute the ZtC 
        %           |- config mode for Zernique2Command computation
        %           |               |- diameter used for ZtC
        %           |               |        |- central obscurtion used in [m]
        %           |               |        |    |- n Eigen Value value 
        %           |               |        |    |   |- nZernike number of Zernique to keep 
        ztcDef = {
                  {'naomi',        28.0e-3, 0.0, 140, 100},
                  {'naomi-sparta', 28.0e-3, 0.0, 140, 21 }, 
                  {'full',         36.5e-3, 0.0, 220, 100}
                };
        % current ztcMode 
        ztcMode = 'naomi';
        % ZtC pupill size used for computation in m 
        ztcPupillDiameter = 28.0e-3;
        % The central obstruction used for ZtC computation 
        ztcCentralObscurtionDiameter = 0.0; 
        % number of eigen value for Zernique to command matrix 
        ztcNeigenValue = 140;
        % number of Zernique to command matrix 
        ztcNzernike = 100;


        % Assumed aproximative pixel scale for start-up alignment
        pixelScale = 0.38e-3; % m / pixel
        
        
        % center actuator id number
        dmCentralActuator = 121;       
        
        % separation between actuators in [m]
        dmActuatorSeparation = 2.5e-3;

        % 1/0 put -1 force to ask user with getRemoveReferenceTipTilt
        removeReferenceTipTilt = -1;
        
        %default number of phase average 
        defaultNphase = 1;

        % number of Np for phase refernence
        phaseRefNphase = 2;


        % number of push pull for DM center computation
        centerNpushPull = 2;
        % push pull ampliture for DM center computation
        centerAmplitude = 0.15;
        % number of pushPull for wfs pixel scale computation 
        scaleNpushPull = 1;
        scaleAmplitude = 0.1;
       

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %  IFM measurement  
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % define usable IF/IFM parameters 
        ifDef = {
                       % |- ifNpushPull
                       % |  |- ifAMplitude 
                       % |  |     |- ifmNloop
                       % |  |     |  |- ifmPause 
            {'quick',    1, 0.3,  1, 0.0},
            {'accurate', 2, 0.35, 2, 1.0}
            
        };
        % quick or accurate leave it '' to ask user 
        ifMode = '';

        %%
        % The 4 following parameters will be modified 
        % when ifMode is changed
        % default nPushPull for IF and IFM computation 
        ifNpushPull = 1;
        % default Amplitude for IF and IFM computation 
        ifAmplitude = 0.3;
        % default number of llop for IFM computation 
        ifmNloop = 1;
        % default pause (in sec) between actuator for IFM 
        ifmPause = 0.0;

        %%
        % IFM cleaning parameter 
        ifmCleanPercentil = 50;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %  Zernique to Phase measurement 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ztpNpushPull = 1;
        ztpAmplitude = 0.25;
        % put negative to take the total number of zernike in dm.zernike2Command
        ztpNZernike = 21;
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   Flat measurement 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        % flat measurement, number of phase 
        flatNphase = 5; 
        
        % gain used to measure the flat in close loop 
        flatCloseGain = 0.5;
        % number of Zernique to close the loop on flat 
        flatCloseNzernike  = 15;
        % number of iteration to close loop on flat 
        flatCloseNstep  = 10;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   Stroke  measurement 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
        % the minimum and maximum fraction of zernike to command amplitude 
        strokeMinAmpFrac = 0.05;
        strokeMaxAmpFrac = 0.97;
        % number of measured points 
        strokeNstep = 10; 
                


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

        % Specify if the gimbal is used on the bench and motorized
        useGimbal = true;
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
            
        %%%%%%%%%%%%%%
        %
        % Graphical configuration 
        % see the figure function for figure placement
        %%%%%%%%%%%%%%
        % rescale the area where the standart figure will be ploted 
        screenHorizontalScale = 0.5;
        screenVerticalScale   = 0.5;
        % ofsset of this area 
        screenHorizontalOffset = 0;
        screenVerticalOffset = 0;
        
        % grid define the position of area where the plot will be ploted
        %              |- horizontal screen size in pixel
        %              |     |- vertical screen size in pixel
        %              |     |    |- horizontal offset in pixel
        %              |     |    |  |- vertical offset in pixel
        %              |     |    |  |  |- h grid resolution
        %              |     |    |  |  |    |- v grid resolution
        screenGrid = {1900, 1000, 0, 0, 100, 100};




        % some constant
        IPAG = 'IPAG';
        ESOHQ = 'ESO-HQ';
        BENCH = 'Bench';
        DUMMY = 'DUMMY';
        
        
        % define the properties / FITS key / fits comment used by writeFits Header
        propDef = {
                     {'tplName' ,       'TPL_NAME','kind of the measurement'},
                     {'location',       'ORIGIN',  'Where data has been taken IPAG/ESO-HQ/BENCH'},
                     {'mjd',            'MJD-OBS', 'Modified Julian Date of writing header'},
                     {'dateobs',        'DATE-OBS','Date of writing header'},
                     {'dmID',           'DM-ID' ,  'DM identification'},
                     {'fullPupillDiameter', 'FPUPDIAM', 'Full DM Pupill Diamter [m]'},                    
                     {'dmCentralActuator',    'CENTACT', 'DM center actuator number'},                     
                     {'centerNpushPull',      'CTNPP',   'Number of push/pull for IFC computation'},
                     {'centerAmplitude','CTAMP',   'push/pull amplitude for IFC computation'}, 
                     {'scaleNpushPull',       'SCNPP',   'Number of push/pull for scale computation'}, 
                     {'scaleAmplitude', 'SCAMP',   'push/pull amplitude for scale computation'}, 
                     {'referenceNp',    'RFNP',    'Number of push for flat/reference measurement'},
                     {'rXOrder',        'RXORDER', 'Zernike order or rx motor movement'},
                     {'rYOrder',        'RYORDER', 'Zernike order or ry motor movement'},
                     {'rXSign',         'RXSIGN',  'Zernike sign or rx positive motor movement'},
                     {'rYSign',         'RYSIGN',  'Zernike sign or ry positive motor movement'}, 
                     {'naomiVecrion',   'VERSION', 'naomi calibartion bench software version'}
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
                    obj.ifNpushPull = def{2};
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
                    obj.ztcCentralObscurtionDiameter = def{3};
                    obj.ztcNeigenValue = def{4};
                    obj.ztcNzernike = def{5};
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

        function posVector = grid2screen(obj, hPos, vPos, hSize, vSize)
            G = obj.screenGrid;
            if hPos<0.0; hPos = G{5}+hPos; end;
            if vPos<0.0; vPos = G{6}+vPos; end;
            posVector = [ G{3} + G{1}*(hPos/G{5}), ...
                          G{4} + G{2}*(vPos/G{6}), ...
                          G{1}*(hSize/G{5}), ...
                          G{2}*(vSize/G{6}) ];
            
        end
        function fig = figure(obj, name)
            fig = findobj('type','figure','name',name);

            if isempty(fig); 
                fig = figure('name',name);
                switch name         
                    %% figure related to configuration 
                    case 'Phase Reference'
                        set(fig, 'Position', obj.grid2screen(0,-10,13,10)); 
                    case 'Phase Mask'
                        set(fig, 'Position', obj.grid2screen(13,-10,13,10));                                 
                    case 'Zernique to Command' 
                        set(fig, 'Position', obj.grid2screen(0,-20,26,10)); 
%                     case 'Influence Function'
%                     %% figure related to measurement 
%                     case 'Last Phase'
%                         set(fig, 'Position', [sX*sH+dH-300*sH, sY*sV+dV-300*sV, 300*sH, 300*sV]);                     
%                     case 'Best Flat' 
%                         set(fig, 'Position', [sX*sH+dH-300*sH, sY*sV+dV-900*sV, 300*sH, 300*sV]);
%                     case 'IF Central Actuator'
%                         set(fig, 'Position', [1000*sH+dH, 1400*sV+dV, 300*sH, 300*sV]);
%                     case 'Modal Stroke'
%                         set(fig, 'Position', [2000*sH+dH, 2000*sV+dV, 300*sH, 600*sV]);
%                     case 'Mode'
%                     %% figures related to actions 
%                     case 'Alignment'
                end
            else set(0, 'CurrentFigure', fig); end;
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

    end
end


