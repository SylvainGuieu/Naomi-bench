classdef Config < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        verbose = 2; % verbose level for NAOMI measurement/action/config ... 
        plotVerbose = true; % standalone plot are ploted or not when doing measurement 
        % turn on/off the simulator 
        simulated = 0;
        simulatorIFM = '/Users/guieus/DATA/NAOMI/IFM_direct.fits';
        simulatorZtC = '/Users/guieus/DATA/NAOMI/NTC_2018-04-03T11-19-30.fits';
        simulatorBias;
        simulatorTurbu = '/Users/guieus/DATA/NAOMI/turbu.fits';
        
        % software version. This is writen in the fits files to eventualy check one
        % day for uncompatibilities 
        naomiVersion = '01-04-2018';
        
        % location where the script has been started
        location = 'Bench';
        
        % default tplName as writen in data header products 'TPL_NAME'
        tplName = 'TEST';

        dataDirectory = 'N:\Bench\Data';
        configDirectory = 'N:\Bench\Config';
        % the session name is not mendatory to set here
        % it will be created on the fly when the mirror is selected
        % the sessionDirectory will be cataDirectory/yyy-mm-dd/sessionName
        sessionName;
        
        % ACE root directory 
        ACEROOT =  'C:\AlpaoCoreEngine';
        
        dmIdChoices = {'BAX153','BAX159','BAX199','BAX200', 'BAX201', 'DUMMY'};
        dmId = '';
        
        % the dm id 2 gimbal assignment loockup table
        dmId2gimbalNumber = {{'BAX153',4},{'BAX159',2},{'BAX199',3},...
                             {'BAX200',1},{'BAX201',5}};
        
        % model of the wfs device currently only 'haso128' is accepted
        wfsModel = 'haso128';
        % haso 128 configuration file 
        haso128cFile = 'C:\Program Files (x86)\Imagine Optic\Configuration Files\HASO3_128_GE2_4651';
        % haso serial needed for connection 
        haso128Serial = 'M660FA';
        
        % PI motor driver 
        piMotorDriver = 'C:\Users\Public\PI\PI_MATLAB_Driver_GCS2';
        piControlerSerial = '0175500223';
        
        % flag for tiptilt removal when measuring phase by
        % naomi.measure.phase
        filterTipTilt = false;
    
        % flag to remove a reference (if any stored in the bench object) 
        % to the measured phased by naomi.measure.phase
        substractReference = true;
        
        % Bench pupill diameter size in m
        % this is the physical pupill of the DM on the bench 
        % not the one used for ZtC (see bellow)  
        fullPupillDiameter = 36.5e-3;
        
        % define typical mask here in naomi, mask can be called by their name
        % or by a 3xCell array defining the {diameter, central-obscurtion-diameter, unit}
        %  unit can be 'm' (converted in pixel by xPixelScale and yPixelSCale) or 'pixel' 
        %           |- mask nam 
        %           |        |- diameter (in given unit)
        %           |        |         |- central obscuration diameter (in given unit)
        %           |        |         |     |- unit 'm' or 'pixel'      
        maskDef = {
                    {'naomi', 28.0e-3,  0.0, 'm'}, ...
                    {'dm',  36.5e-3, 0.0, 'm'},... 
                    {'no mask',  999.9e-3, 0.0,  'm'}% big mask = no mask 
        };
        
        
        % some typical mode to compute the ZtC 
        %           |- config mode for Zernique2Command computation
        %           |               |- mask name or definition 
        %           |               |        
        %           |               |       |- n Eigen Value value 
        %           |               |       |   |- nZernike number of Zernique to keep 
        %           |               |       |   |     |- zeroMean  
        ztcDef = {
                  {'naomi-pup',        'naomi', 140, 100, 1},
                  {'naomi-pup-sparta', 'naomi', 140, 21 , 1}, 
                  {'dm-pup',           'dm',    140, 100, 1}
                  {'no mask',      'no mask',   220, 100, 1} % make a big mask = no mask 
                };
                
        % current ztcMode 
        ztcMode = 'naomi';
        %%
        % add default to the ztc parameters
        % current ztcMask 
        ztcMask = 'naomi';
        
        % number of eigen value for Zernique to command matrix 
        ztcNeigenValue = 140;
        % number of Zernique to command matrix 
        ztcNzernike = 100;
        
        % number of Zernique to command matrix for the ZtP measurement
        ztpNzernike = 21;
        
        % 1 or 0 zeroMean for matrix inversion 
        ztcZeroMean = 1;
        % the haso wafe front sensor dit at startup
        wfsDit = 2.0; % this is the min dit
         
        % min and max flux, receive by the wfs, tresholds when adjusting
        bestMinFlux = 0.6;
        bestMaxFlux = 0.9;
        % the min flux for which we cannot work 
        minFlux = 0.1;
        
        % Assumed aproximative pixel scale for start-up alignment
        % normaly, after measurement this value is not used anymore
        xPixelScale = 0.38e-3; % m / pixel
        yPixelScale = 0.38e-3; % m / pixel
        
        %% 
        % Assumed aproximative x,y center for start-up alignment
        % normaly, after measurement this value is not used anymore
        % For the central actuator position:
        xCenter = 64.0; % pixel 
        yCenter = 64.0; % pixel
        % For the pupill circle trace on the wave front:
        xPupillCenter = 64.0; % pixel 
        yPupillCenter = 64.0; % pixel
        
        
        % orientation is used to determine the correspondance between the 
        % receive phase / dm position and conventional zernike definition
        % when plotted the phase screen is left untouched but the DM can be
        % rotated as well as theoritical phases
        % orientation can be 
        %   'xy' : phase screen and dm in the same orientation
        %   'yx' : phase screen and dm are rotated by 90 degree
        %   '-xy' : the x axis is flipped 
        %   'x-y' : y axis is flipped 
        %   '-x-y' : x and y axis flipped 
        %   etc ...
        % After measured by the bench this value is not used anymore
        orientation = 'yx';
        
        dmasdasda= [39,203];
        
        % center actuator id number
        dmCentralActuator = 121;       
        
        % separation between actuators in [m]
        dmActuatorSeparation = 2.5e-3;

        % 1/0 put -1 force to ask user with getRemoveReferenceTipTilt
        removeReferenceTipTilt = -1;
        
        %default number of phase average 
        defaultNphase = 1;

        % number of Nphase for phase refernence
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
        
        % flat prefered mode (for gui use) 'closed' or 'open'
        flatLoopMode = 'closed';
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
        % parameters when measuring the dm Bias 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
        
        % the ztcMode used to compute the matrix (PtC)
        % leave empty to use default parameters
        biasZtcMode = 'full-pupill';
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   zernike  measurement 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
         % zernike measurement prefered mode (for gui use) 'closed' or 'open'
        zernikeLoopMode = 'open';
        % zerniket measurement, number of phase 
        zernikeNphase = 1; 
        % amplitude used to play the zernike (for gui use)
        zernikeAmplitude = 1.0;
        % gain used to measure the zernike in close loop 
        zernikeCloseGain = 0.5;
        % number of Zernique to close the loop on zernike
        zernikeCloseNzernike  = 15;
        % number of iteration to close loop on zernike
        zernikeCloseNstep  = 10;
        
        
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
        % the motor command gain for the auto alignment 
        pupillTipTiltAlignGain = 0.5;
        
        %%%%%%%%%%%%%%%%%%%%%
        % gimbal movement specification 
        %%%%%%%%%%%%%%%%%%%%%

        % Specify if the gimbal is used on the bench and motorized
        useGimbal = true;
        % Which order correspond to rX and rY motor movement tip or tilt 
        rXOrder = 'tilt';  %tip
        rYOrder = 'tip'; % not used just for consistancy
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
        gimbalsDef =   {{1,14.5,15.7, 3300, 5000},...
                        {2,14.5,15.7, 3300, 5000},...
                        {3,14.5,15.7, 3300, 5000},...
                        {4,14.4405,15.8042, 3300, 5000},...%measure @ipag with wave view
                        {5,14.5,15.7, 3300, 5000}
                       };
        % these parameters are modified when the gimbalNumber is set 
        gimbalRxZero = 14.3963; % as aligned in IPAG 
        gimbalRyZero = 15.6511; 
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
        %              |- horizontal screen size in pixel (-1 for auto)
        %              |     |- vertical screen size in pixel (-1 for auto)
        %              |     |    |- horizontal offset in pixel
        %              |     |    |  |- vertical offset in pixel
        %              |     |    |  |  |- h grid resolution
        %              |     |    |  |  |    |- v grid resolution
        screenGrid = {-1,   -1, 0, 0, 100, 100};




        % some constant
        IPAG = 'IPAG';
        ESOHQ = 'ESO-HQ';
        BENCH = 'Bench';
        DUMMY = 'DUMMY';
        
        TIP = 'tip';
        TILT = 'tilt';
        
        % define the properties / FITS key / fits comment used by writeFits Header
        propDef = {
                     {'tplName' ,       'TPL_NAME','kind of the measurement'},
                     {'location',       'ORIGIN',  'Where data has been taken IPAG/ESO-HQ/BENCH'},
                     {'mjd',            'MJD-OBS', 'Modified Julian Date of writing header'},
                     {'dateobs',        'DATE-OBS','Date of writing header'},
                     {'dmId',           'DM-ID' ,  'DM identification'},
                     {'fullPupillDiameter', 'FPUPDIAM', 'Full DM Pupill Diamter [m]'},                    
                     {'dmCentralActuator',    'CENTACT', 'DM center actuator number'},                     
                     {'centerNpushPull',      'CTNPP',   'Number of push/pull for IFC computation'},
                     {'centerAmplitude','CTAMP',   'push/pull amplitude for IFC computation'}, 
                     {'scaleNpushPull',       'SCNPP',   'Number of push/pull for scale computation'}, 
                     {'scaleAmplitude', 'SCAMP',   'push/pull amplitude for scale computation'}, 
                     {'rXOrder',        'RXORDER', 'Zernike order or rx motor movement'},
                     {'rYOrder',        'RYORDER', 'Zernike order or ry motor movement'},
                     {'rXSign',         'RXSIGN',  'Zernike sign or rx positive motor movement'},
                     {'rYSign',         'RYSIGN',  'Zernike sign or ry positive motor movement'}, 
                     {'naomiVersion',   'VERSION', 'naomi calibartion bench software version'}
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
        end

        function log(obj, str, level)
            if nargin<3
                level = obj.verbose;
            end
            naomi.log(str, level, obj.verbose);
        end
        
        
          
        function dir = todayDirectory(obj);
            dir = fullfile(obj.dataDirectory, datestr(now,'yyyy-mm-dd'));
            if ~exist(dir, 'file')
                mkdir(dir);
            end
        end
        function dir = sessionDirectory(obj)
            if isempty(obj.sessionName)
                dir = obj.todayDirectory;
            else
                dir = fullfile(obj.todayDirectory, obj.sessionName);
                if ~exist(dir, 'file')
                    mkdir(dir);
                end
            end
        end
        
        function test = isDm(obj)
            % true if the current configured mirror is a dm otherwise false
            switch obj.dmId
                case obj.DUMMY
                    test = 0;
                otherwise
                    test = 1;
            end
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
                if strcmp(mode,def{1})
                    obj.ifNpushPull = def{2};
                    obj.ifAmplitude = def{3};
                    obj.ifmNloop = def{4};
                    obj.ifmPause = def{5};
                    found = true;
                end
            end
            if ~found; error(sprintf('unknown mode %s',mode)); end 

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
            [gid,~] = listdlg('PromptString','Select IFM measurement mode:','SelectionMode','single','ListString',ifModes);
            obj.ifMode = ifModes{gid};
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
                if strcmp(mode,def{1})
                    obj.ztcMask = def{2};
                    
                    obj.ztcNeigenValue = def{3};
                    obj.ztcNzernike = def{4};
                    obj.ztcZeroMean = def{5};
                    found = true;
                end
            end
            if ~found; error(strcat('unknown mode ',mode)); end 

            obj.ztcMode = mode; 
        end 
        function [mask, nEigenValue, nZernike, zeroMean] = ZtCParameters(obj, ztcMode)
          if nargin<2 || isempty(ztcMode)
            mask = obj.ztcMask
            nEigenValue = obj.ztcNeigenValue;
            nZernike = obj.ztcNzernike;
            zeroMean = obj.ztcZeroMean;
            return;
          end
          
          if iscell(ztcMode)
              
              if length(ztcMode)>0
                mask = ztcMode{1};
              else
                mask = obj.ztcMask;
              end
              if length(ztcMode)>1
                nEigenValue = ztcMode{2};
              else
                nEigenValue = obj.ztcNeigenValue;
              end
              if length(ztcMode)>2
                nZernike = ztcMode{3};
              else
                nZernike = obj.ztcNzernike;
              end
              if length(ztcMode)>2
                zeroMean = ztcMode{4};
              else
                zeroMean = obj.ztcZeroMean;
              end
              return; 
          end
          
          found = false;
          for i=1:length(obj.ztcDef)
              def = obj.ztcDef{i};
              if strcmp(mode,def{1})
                  mask = def{2};
                  nEigenValue = def{3};
                  nZernike = def{4};
                  zeroMean = def{5};
                  found = true;
              end
          end
          if ~found; error(strcat('unknown mode ',mode)); end 
            
        end
        function ztcModes = ztcModeChoices(obj)
            ztcModes = {};
            for i=1:length(obj.ztcDef)
                ztcModes{i} = num2str(obj.ztcDef{i}{1});
            end
        end
        function askZtcMode(obj)
            ztcModes = obj.ztcModeChoices;
            [gid,~] = listdlg('PromptString','Select ztcM measurement mode:','SelectionMode','single','ListString',ztcModes);
            obj.ztcMode = ztcModes{gid};
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
        %   mask set/ask/get/choices function 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function maskNames = maskChoices(obj)
            maskNames = {};
            for i=1:length(obj.maskDef)
                maskNames{i} = obj.maskDef{i}{1};
            end
        end
        function mask = askMask(obj)
            masks = obj.maskChoices;
            [gid,~] = listdlg('PromptString','Select mask :','SelectionMode','single','ListString',masks);
            mask = masks{gid};
        end
        
        function [mask,maskName] = getMask(obj, maskInput)
            % return IfMode or ask 
            maskName = 'UNKNOWN';
            if nargin<2 || isempty(maskInput)
                maskInput = obj.askMask()
            end
            
            if isstr(maskInput) || isstring(maskInput)
              found = false;
              maskName = maskInput;
              for i=1:length(obj.maskDef)
                  def = obj.maskDef{i};
                  
                  if strcmp(maskInput,def{1})
                      mask = def(2:end);
                      
                      found = true;
                  end
              end
              if ~found; error(strcat('unknown mode ',mode)); end 
            else
              if iscell(maskInput)
                if length(maskInput)~=3
                  error('mask must be a string, a 3xcell array or a Matrix');
                end
                mask = maskInput;
              else
                if ~ismatrix(maskInput)
                  error('mask must be a string, a 3xcell array or a Matrix');
                end
                 mask = maskInput;                
              end
            end
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
        function gimbalNumber = assignGimbal(obj)
          % assign the gimbal with the given dmId 
          % if dmId is not in the lookup table dmId2gimbalNumber
          % the configuration is left has is.
          % the gimbal number is returned and is -9 if no match found
          dmId = obj.dmId;
          gimbalNumber = -9;
          for iTab=1:length(obj.dmId2gimbalNumber) 
            pair = obj.dmId2gimbalNumber{iTab};
            if strcmp(pair{1},dmId)
               obj.gimbalNumber = pair{2};
               gimbalNumber =  pair{2};
            end
          end 
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %
        %   dmId set/ask/get/choices function 
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        function askDmId(obj)
             % ask the dmId from a dialog box
             dmIds = obj.dmIdChoices;
             [iDmID,~] = listdlg('PromptString','Select a DM:','SelectionMode','single','ListString',dmIds);
             obj.dmId = char(dmIds(iDmID));
        end
        function dmId = getDmId(obj)
            % return DmID or ask 
            if strcmp(obj.dmId, '')
                obj.askDmId()
            end
            dmId = obj.dmId
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
            if G{1}<0 || G{2}<0
                % size inferior to zero,  change it to the screen size
                % the first time.
                set(0,'units','pixels');
                screenSizes = get(0,'screensize');
                if G{1}<0; G{1} = screenSizes(3); end
                if G{2}<0; G{2} = screenSizes(4); end
            end
            if hPos<=0.0; hPos = G{5}+hPos; end;
            if vPos<=0.0; vPos = G{6}+vPos; end;
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
                        set(fig, 'Position', obj.grid2screen(1,-10,13,10)); 
                    case 'Phase Mask'
                        set(fig, 'Position', obj.grid2screen(13,-10,13,10));                                 
                    case 'Zernique to Command' 
                        set(fig, 'Position', obj.grid2screen(1,-20,26,10));
                    case 'Last Phase'
                         set(fig, 'Position',obj.grid2screen(-20,-28,20,28));
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


