% Control du peltier%
% $Q Clear RUN flag <Stop>
% $W Set Run flag <Run>
% $V Show current software version <version string>
% $v Show current software version and interface
% version
% <version string><interface version>
% $S Get status flag <flag1><alarm1><alarm2>
% $SC Clear status flag <flag1><alarm1><alarm2>
% $RW Write regulator register values to EEPROM
% $RR Display regulator register <parameter list>
% $Rxx=data Write data (float or int) to register xx If int <Downloaded data>
% If float <no response>
% $Rxx? Read data (float or int) from register xx ex. +2.000e+01
% $RNxx=data Write float data in IEEE754 type to register xx
% $RNxx? Read float data in IEEE754 type from register
% xx
% ex. A1A8FCBA
% $Ax Continuous log of values, where X is 1..7 continues data
% $B Enter BOOT LOADER mode (described in a boot
% loader document)
% Se bootloader document
% $BC Reboot the board boot text
% $LI Get board info and ID name ID string of data
% $LD Display logg data (max/min/avr) <num> VIN, CURR, T1, T4
% $LL Load logg data from eeprom to ram <num> VIN, CURR, T1, T4
% $LC Clear logg data in eeprom, use with care <num> VIN, CURR, T1, T4
% <CR> Perform last command As previous command
% Unknown command ?<command>

% Register Default value R/W Type Description
% 0 20.0 RW float/IEEE Set Point - (fgTref) Main temperature reference
% 1 20.0 RW float/IEEE PID � (Kp) P constant
% 2 2.0 RW float/IEEE PID � (Ki) I constant
% 3 5.0 RW float/IEEE PID � (Kd) D constant
% 4 2.0 RW float/IEEE PID � (KLP_A) Low pass filter A (+value)
% 5 3.0 RW float/IEEE PID � (KLP_B) Low pass filter B (+value)
% 6 100.0 RW float/IEEE MAIN � (TcLimit) Limit the Tc signal (0..100)
% 7 3.0 RW float/IEEE MAIN � (TcDeadBand) Dead band of Tc signal
% (0..100)
% 8 100.0 RW float/IEEE PID � (iLim) Limit I value (0..100)
% 9 0.05 R float/IEEE MAIN � (Ts) Sample rate 1/Hz
% 10 1.0 RW float/IEEE MAIN � (Cool Gain) Gain of cool part of Tc signal
% (+value)
% 11 1.0 RW float/IEEE MAIN � (Heat Gain) Gain of heat part of Tc signal
% (+value)
% 12 0.1 RW float/IEEE PID � (Decay) Decay of I and low pass filter part
% (+value)
% 13 128 RW int REGULATOR MODE � Control register
% 14 5.0 RW float/IEEE ON/OFF Dead band (+value)
% 15 5.0 RW float/IEEE ON/OFF Hysteresis (+value)
% 16 0 RW int FAN 1 Mode select
% 17 20.0 RW float/IEEE FAN 1 Set temperature
% 18 8.0 RW float/IEEE FAN 1 Dead band (+value)
% 19 4.0 RW float/IEEE FAN 1 Low speed hysteresis (+value)
% 20 2.0 RW float/IEEE FAN 1 High speed hysteresis (+value)
% 21 30.0 RW float/IEEE FAN 1 Low Speed voltage (0..30)
% 22 30.0 RW float/IEEE FAN 1 High Speed voltage (0..30)
% 23 0 RW int FAN 2 Mode select
% 24 20.0 RW float/IEEE FAN 2 Set temperature
% 25 8.0 RW float/IEEE FAN 2 Dead band (+value)
% 26 4.0 RW float/IEEE FAN 2 Low speed hysteresis (+value)
% 27 2.0 RW float/IEEE FAN 2 High speed hysteresis (+value)
% 28 30.0 RW float/IEEE FAN 2 Low Speed voltage (0..30)
% 29 30.0 RW float/IEEE FAN 2 High Speed voltage (0..30)
% 30 0 RW float/IEEE POT input - AD offset
% 31 0 RW float/IEEE POT input - offset
% 32 1 RW float/IEEE POT input - gain
% 33 0 RW float/IEEE Expansion port AD out � offset
% 34 1 RW float/IEEE Expansion port AD out - gain
% 35 1.0 RW float/IEEE Temp 1 gain
% 36 0.0 RW float/IEEE Temp 1 offset
% 37 1.0 RW float/IEEE Temp 2 gain
% 38 0.0 RW float/IEEE Temp 2 offset
% 39 1.0 RW float/IEEE Temp 3 gain
% 40 0.0 RW float/IEEE Temp 3 offset
% 41 1.0 RW float/IEEE Temp FET gain
% 42 0.0 RW float/IEEE Temp FET offset
% 43 - RW int Temp 1 digital pot offset (0..255)
% 44 - RW int Temp 1 digital pot gain (0..255)
% 45 30.0 RW float/IEEE ALARM level voltage high
% 46 10.0 RW float/IEEE ALARM level voltage low
% 47 15.0 RW float/IEEE ALARM level main current high
% 48 0.1 RW float/IEEE ALARM level main current low
% 49 2.0 RW float/IEEE ALARM level FAN 1 current high
% 50 0.1 RW float/IEEE ALARM level FAN 1 current low
% 51 2.0 RW float/IEEE ALARM level FAN 2 current high
% 52 0.1 RW float/IEEE ALARM level FAN 2 current low
% 53 13.0 RW float/IEEE ALARM level internal 12v high
% 54 7.0 RW float/IEEE ALARM level internal 12v low
% 55 12 RW int Temp1 mode
% 56 4 RW int Temp2 mode
% 57 4 RW int Temp3 mode
% 58 4 RW int Temp4 mode
% 59 1.396917e-03 RW float/IEEE Temp1 Steinhart coeff A
% 60 2.378257e-04 RW float/IEEE Temp1 Steinhart coeff B
% 61 9.372652e-08 RW float/IEEE Temp1 Steinhart coeff C
% 62 1.396917e-03 RW float/IEEE Temp2 Steinhart coeff A
% 63 2.378257e-05 RW float/IEEE Temp2 Steinhart coeff B
% 64 9.372652e-07 RW float/IEEE Temp2 Steinhart coeff C
% 65 1.396917e-03 RW float/IEEE Temp3 Steinhart coeff A
% 66 2.378257e-05 RW float/IEEE Temp3 Steinhart coeff B
% 67 9.372652e-07 RW float/IEEE Temp3 Steinhart coeff C
% 68 6.843508e-03 RW float/IEEE Temp4 Steinhart coeff A
% 69 2.895852e-04 RW float/IEEE Temp4 Steinhart coeff B
% 70 -8.177021e-08 RW float/IEEE Temp4 Steinhart coeff C
% 71 80.0 RW float/IEEE ALARM Temp 1 high
% 72 -40.0 RW float/IEEE ALARM Temp 1 low
% 73 50.0 RW float/IEEE ALARM Temp 2 high
% 74 -10.0 RW float/IEEE ALARM Temp 2 low
% 75 50.0 RW float/IEEE ALARM Temp 3 high
% 76 -10.0 RW float/IEEE ALARM Temp 3 low
% 77 60.0 RW float/IEEE ALARM Temp 4 high
% 78 -10.0 RW float/IEEE ALARM Temp 4 low
% 79 759.4 RW float/IEEE Temp1 Steinhart resistance value H
% 80 3057.7 RW float/IEEE Temp1 Steinhart resistance value M
% 81 29875.8 RW float/IEEE Temp1 Steinhart resistance value L
% 82 759.4 RW float/IEEE Temp2 Steinhart resistance value H
% 83 3057.7 RW float/IEEE Temp2 Steinhart resistance value M
% 84 29875.8 RW float/IEEE Temp2 Steinhart resistance value L
% 85 759.4 RW float/IEEE Temp3 Steinhart resistance value H
% 86 3057.7 RW float/IEEE Temp3 Steinhart resistance value M
% 87 29875.8 RW float/IEEE Temp3 Steinhart resistance value L
% 88 2965.14 RW float/IEEE Temp4 Steinhart resistance value H
% 89 28836.8 RW float/IEEE Temp4 Steinhart resistance value M
% 90 78219 RW float/IEEE Temp4 Steinhart resistance value L
% 91 351 RW uint Alarm enable bits low
% 92 255 RW uint Alarm enable bits high
% 93 8.0 RW float/IEEE Setpoint 2, when in test loop mode
% 94 300 RW unit TimeHigh, when in loop mode (cycles)
% 95 200 RW unit TimeLow, when in loop mode (cycles)
% 96 65532 RW uint Sensor Alarm Mask, select warning or alarm of
% sensors
% 99 - R uint Regulator event count. Increments one time each
% regulator event.
% 100 - R float/IEEE Temp 1 value (AN5)
% 101 - R float/IEEE Temp 2 value (AN6)
% 102 - R float/IEEE Temp 3 value (AN7)
% 103 - R float/IEEE Temp FET value (AN8)
% 104 - R float/IEEE Temp POT reference (AN0)
% 105 - R float/IEEE TRef
% 106 - R float/IEEE MAIN (Tc) output value (-100..+100)
% 107 - R float/IEEE FAN 1 output value (0..100)
% 108 - R float/IEEE FAN 2 output value (0..100)
% 110 - R float/IEEE PID � Ta
% 111 - R float/IEEE PID � Te
% 112 - R float/IEEE PID � Tp
% 113 - R float/IEEE PID � Ti
% 114 - R float/IEEE PID � Td
% 117 - R float/IEEE PID � TLP_A
% 118 - R float/IEEE PID � TLP_B
% 122 - R int ON/OFF � runtime state
% 123 - R float/IEEE ON/OFF � runtime max
% 124 - R float/IEEE ON/OFF � runtime min
% 125 - R int FAN1 � runtime state
% 126 - R float/IEEE FAN1 � runtime max
% 127 - R float/IEEE FAN1 � runtime min
% 128 - R int FAN2 � runtime state
% 129 - R float/IEEE FAN2 - runtime max
% 130 - R float/IEEE FAN2 � runtime min
% 150 - R float/IEEE (AN1) Input voltage
% 151 - R float/IEEE (AN10) Internal 12v
% 152 - R float/IEEE (AN9) Main current
% 153 - R float/IEEE (AN11) FAN1 current
% 154 - R float/IEEE (AN4) FAN2 current
% 155 - RW float/IEEE FAN1 and FAN2 internal gain value (do not use)


classdef Environment < naomi.objects.BaseObject
    % Interface for all environmental value and command 
    % temperatures, fan rotation, etc..   
    
    properties
        client;
        zero;
        verbose;
        
        monitoringBuffer;
        monitoringTimer;
        monitoringIsRunning = 0;
        monitoringAxesList; 
        
        controlTimer;
        controlIsRunning = 0;
        controlState = 0; % one of the state below
        
        % call back function executed after each updateControl 
        % usefull to e.i. plot temperatures in a gui  
        controlCallback; 
        
        %% control constant definition
        % setting the bench mirror temperature at embiant when achived 
        % the state should be OFF
        WARMUP2EMBIANT = 1; 
        COOLDOWN2EMBIANT = 2; 
        
        % setting the bench at calibration temperature. when embiant 
        % temperature is above regulation temperature 
        % After it reaching it the state should be REGUL
        COOLDOWN2CALIB = 3; 
        
        % setting the bench at calibration temperature. when embiant 
        % temperature is bellow regulation temperature 
        % After it reaching it the state should be REGUL
        WARMUP2CALIB = 4; 
        
        % Maintain the bench temperature by adjusting the peltier cold face
        % temperature (at about the calib temperature) and the fan 
        MAINTAIN = 5;
        % Turn off the fan and put the peltier to the calib temperature for
        % calibration 
        CALIB = 6;
        %  matlab temperature control turned off 
        OFF = 0;
        
        %% temperature setting *OVERWRITTEN BY CONFIG PARAMETERS*
        % calibTemperature 
        calibTemperature = 10.0 
        
        % acceptable difference of temperature between 
        % mirror and embiant                     
        safeDeltaTemp = 2.0 
        
        % temperature difference forwhich it is acceptable to start calibration
        % abs(e.getTemp(e.MIROR)-e.calibTemperature) < e.calibDeltaTemp               
        calibDeltaTemp = 0.25 
        
        % temperature of regulation (this is not the mirror temp but the
        % peltier cold face) for cooldown
        cooldown2calibTemperature =  5.0;
        % same thing for warming up the bench to calib temp
        warmup2calibTemperature =  15.0;
        
        % difference of temperature between embiant and regul when cooling
        % down the bench to embiant
        cooldown2embiantDeltaTemperature = 1.0;
        % samething for warming it up 
        warmup2embiantDeltaTemperature = 1.0;
        
        % the regul temperature to maintain the bench at calib temperature 
        % when the calibration is running
        cooldown2maintainTemperature = 10.0; % when cooling down
        warmup2maintainTemperature = 10.0; % when warming up 
        
        % the fan absolute voltage for witch it is acceptable to start and 
        % or run calibration
        calibFanVoltage = 0.0;
        % fan voltage when cooling down to calib temperature 
        cooldown2calibFanVoltage = 24.0;
        % fan voltage when warming up to calib temperature 
        warmup2calibFanVoltage = 24.0;
        
        % fan voltage when cooling down to embiant temperature 
        cooldown2embiantFanVoltage = 24.0;
        % fan voltage when warming up to embiant temperature 
        warmup2embiantFanVoltage = 24.0;
        
        % temperature IDs constant 
        REGULSENS = 1;
        COLDFACE = 1;
        HOTFACE = 2;
        EMBIANT = 4;
        MIRROR = 5;
        QSM = 6;
        
        % FAN constant 
        COLDFACEFAN = 1;
        HOTFACEFAN = 2;
        
        % some input registration numbers
        R_REGUL = 0;
        R_COOLGAIN = 10;
        R_WARMGAIN = 11;
        
        R_FAN1_MODE = 16;
        R_FAN1_LSPEED_VOLTAGE = 20;
        R_FAN1_HSPEED_VOLTAGE = 21;
        
        R_FAN2_MODE = 24;
        R_FAN2_LSPEED_VOLTAGE = 28;
        R_FAN2_HSPEED_VOLTAGE = 29;
        
        ALWAYSON = 3;
    end
    
    methods (Access = public)
        function obj = Environment(port)
            return
            fprintf('Init connection to Peltier Controler Laird-ETS-PR-59\n');
            obj.client = serial(port);
            set(obj.client,'BaudRate',115200);
            set(obj.client,'Parity','none');
            set(obj.client,'StopBits',1);
            set(obj.client,'DataBits',8);
            set(obj.client,'Terminator','CR');
            
            fprintf('Open connection to Peltier Controler Laird-ETS-PR-59\n');
            fopen(obj.client);
            obj.zero = 0.0;
            obj.verbose = 1;    
            
        end
        
        
        function delete(obj)
            fprintf('Close connection to Peltier Controler Laird-ETS-PR-59\n');
            obj.stopMonitoring;
            fclose(obj.client);
            
        end
        
        function [test, explanation] = isReadyToCalib(obj)
            % [test, explanation] = e.isReadyToCalib
            % 
            % test is 1 if the bench is ready for calibration 0 otherwhise
            % in case of 0, explanation gives some detail why the bench is
            % not ready
            %          
            explanation = '';
            switch obj.controlState
                case {obj.COOLDOWN2CALIB, obj.WARMUP2CALIB}
                    test = 0;
                    explanation = 'The bench is still actively trying to reach calibration temperature';
                    return 
                case obj.MAINTAIN
                    test = 0;
                    explanation = 'The bench is in regulation state -> fans are on';
                    return 
                case {obj.COOLDOWN2EMBI, obj.WARMUP2EMBIANT}
                    test = 0;
                    explanation = 'The bench is getting to the embiant temperature';
                    return 
            end
            % otherwise check the fan voltage and then the temperature
            fanVoltage = obj.getFanVoltage(obj.COLDFACEFAN);
            if abs(fanVotage-obj.calibFanVoltage)>1e-1
                test = 0;
                explanation = sprintf('The Fan inside the bench is still on : voltage = %.2f', fanVoltage);
                return 
            end
            
            tm = obj.getTemp(obj.MIRROR);
            dt =  tm - obj.calibTemperature;
           if abs(dt) < obj.calibDeltaTemp
               test = 1;
           else
               test = 0;
               explanation = sprintf('The mirror temperature should be %.2f+/-%.2f  but is %.2f', obj.calibTemperature, obj.calibDeltaTemp,tm);
           end
        end
        
        function [test, explanation] = isSafeToOpen(obj)
           explanation = '';
           dt = obj.getTemp(obj.EMBIANT) - obj.getTemp(obj.MIRROR);
           if abs(dt) < obj.safeDeltaTemp
               test = 1;
           else
               test = 0;
               explanation = sprintf('The difference between bench temperature and embiand temperature is %.2f', dt);
           end
        end
        
        
        function updateControl(obj, varargin)
            state = obj.controlState;
            
            temp = obj.getTemp(obj.MIRROR);
            embiantTemp = obj.getTemp(obj.EMBIANT);
            switch state
                case obj.MAINTAIN % regulation to maintain the bench temperature
                    if embiantTemp<obj.calibTemperature % we are warming up to calib temp
                        if (obj.calibTemperature-temp) > obj.calibDeltaTemp
                            obj.goToCalibTemperature()
                        end
                    else
                        if (temp-obj.calibTemperature) > obj.calibDeltaTemp
                            obj.goToCalibTemperature()
                        end
                    end
                   
                case obj.COOLDOWN2CALIB % cooling down to reach calib temperature (bellow embiant)
                    if temp < (obj.calibTemperature-obj.calibDeltaTemp)
                        obj.maintainCalibTemperature;
                    end
                    
                case obj.WARMUP2CALIB % warming upto reach calib temperature (above embiant)
                    if temp > (obj.calibTemperature+obj.calibDeltaTemp)
                        obj.maintainCalibTemperature;
                    end   
                
                case obj.WARMUP2EMBIANT
                    if temp > (embiantTemp)
                        obj.stopRegulation;
                    end
                    
                case obj.COOLDOWN2EMBIANT
                    if temp < (embiantTemp)
                        obj.stopRegulation;
                    end   
            end
            
            if ~isempty(obj.controlCallback)
                obj.controlCallback(obj);
            end
        end
        
        function goToCalibTemperature(obj)
            temp = obj.getTemp(obj.MIRROR);
            embiantTemp = obj.getTemp(obj.EMBIANT);
            if embiantTemp<obj.calibTemperature % we are warming up to calib temp
                obj.warmup2calib;
            else
                obj.coolddown2calib;
            end
        end
        
        function maintainCalibTemperature(obj)
            embiantTemp = obj.getTemp(obj.EMBIANT);
            if embiantTemp>obj.calibTemperature                                
                obj.setRegister(obj.R_REGUL, obj.cooldown2maintainTemperature);
            else
                obj.setRegister(obj.R_REGUL, obj.warmup2maintainTemperature);
            end
            
            
            obj.setRegister(obj.R_FAN1_MODE, obj.ALWAYSON); %always on check the real value !

            obj.setRegister(obj.R_FAN1_HSPEED_VOLTAGE, 0.0); % turn off fan 
            obj.setRegister(obj.R_FAN1_LSPEED_VOLTAGE, 0.0); % turn off fan 

            obj.setRegister(obj.R_FAN2_MODE, obj.ALWAYSON); %always on check the real value !

            obj.setRegister(obj.R_FAN2_HSPEED_VOLTAGE, 0.0); % turn off fan 
            obj.setRegister(obj.R_FAN2_LSPEED_VOLTAGE, 0.0); % turn off fan 
            
            obj.startRegulation;
            obj.controlState = obj.MAINTAIN;
            
        end
        
        function warmup2calib(obj)
            % start warming the bench in order to reach the calibration 
            % temperature 
            
            
            obj.setRegister(obj.R_REGUL, obj.calibTemperature); % temperature 
            obj.setRegister(obj.R_COOLGAIN, 0.0); % cooling gain
            obj.setRegister(obj.R_WARMGAIN, 1.0); % heating gain
            
            obj.setRegister(obj.R_FAN1_MODE, obj.ALWAYSON); %always on check the real value !
            
            obj.setRegister(obj.R_FAN1_HSPEED_VOLTAGE, obj.warmup2calibFanVoltage);
            obj.setRegister(obj.R_FAN1_LSPEED_VOLTAGE, obj.warmup2calibFanVoltage);

            obj.setRegister(obj.R_FAN2_MODE, obj.ALWAYSON); %always on check the real value !
            obj.setRegister(obj.R_FAN2_HSPEED_VOLTAGE, 24.0); %outside fan always at 24v
            obj.setRegister(obj.R_FAN2_LSPEED_VOLTAGE, 24.0); %outside fan always at 24v
            
            obj.startRegulation;
            obj.controlState = obj.WARMUP2CALIB;
            
            
        end
        
        function cooldown2calib(obj)
            % start warming the bench in order to reach the calibration 
            % temperature 
            
            
            obj.setRegister(obj.R_REGUL, obj.calibTemperature); % temperature 
            obj.setRegister(obj.R_COOLGAIN, 1.0); % cooling gain
            obj.setRegister(obj.R_WARMGAIN, 0.0); % heating gain
            
            obj.setRegister(obj.R_FAN1_MODE, obj.ALWAYSON); %always on check the real value !
            obj.setRegister(obj.R_FAN1_HSPEED_VOLTAGE, obj.cooldown2calibFanVoltage);
            obj.setRegister(obj.R_FAN1_LSPEED_VOLTAGE, obj.cooldown2calibFanVoltage);
            
            obj.setRegister(obj.R_FAN2_MODE, obj.ALWAYSON); %always on check the real value !
            obj.setRegister(obj.R_FAN2_HSPEED_VOLTAGE, 24.0); %outside fan always at 24v   
            obj.setRegister(obj.R_FAN2_LSPEED_VOLTAGE, 24.0);
            
            obj.startRegulation;
            obj.controlState = obj.COOLDOWN2CALIB;
        end
        
        
        function warmup2embient(obj)
            % start warming the bench in order to reach the calibration 
            % temperature 
            
            embiantTemperature = obj.getTemp(obj.EMBIANT);
            
            obj.setRegister(obj.R_REGUL, embiantTemperature+obj.warmup2embiantDeltaTemperature); % temperature 
            obj.setRegister(obj.R_COOLGAIN, 0.0); % cooling gain
            obj.setRegister(obj.R_WARMGAIN, 1.0); % heating gain
            
            obj.setRegister(obj.R_FAN1_MODE, obj.ALWAYSON); %always on check the real value !
            
            obj.setRegister(obj.R_FAN1_HSPEED_VOLTAGE, obj.warmup2embiantFanVoltage);
            obj.setRegister(obj.R_FAN1_LSPEED_VOLTAGE, obj.warmup2embiantFanVoltage);
            
            obj.setRegister(obj.R_FAN2_MODE, obj.ALWAYSON); %always on check the real value !
            obj.setRegister(obj.R_FAN2_HSPEED_VOLTAGE, 24.0); %outside fan always at 24v
            obj.setRegister(obj.R_FAN2_LSPEED_VOLTAGE, 24.0);
            
            obj.startRegulation;
            obj.controlState = obj.WARMUP2EMBIANT;
            
        end
        
        function cooldown2embient(obj)
            % start warming the bench in order to reach the calibration 
            % temperature 
            
            embiantTemperature = obj.getTemp(obj.EMBIANT);
            
            obj.setRegister(obj.R_REGUL, embiantTemperature-obj.cooldown2embiantDeltaTemperature); % temperature 
            obj.setRegister(obj.R_COOLGAIN, 1.0); % cooling gain
            obj.setRegister(obj.R_WARMGAIN, 0.0); % heating gain
            
            obj.setRegister(obj.R_FAN1_MODE, obj.ALWAYSON); %always on check the real value !
            
            obj.setRegister(obj.R_FAN1_HSPEED_VOLTAGE, obj.cooldown2embiantFanVoltage);
            obj.setRegister(obj.R_FAN1_LSPEED_VOLTAGE, obj.cooldown2embiantFanVoltage);
            
            obj.setRegister(obj.R_FAN2_MODE, obj.ALWAYSON); %always on check the real value !
            obj.setRegister(obj.R_FAN2_HSPEED_VOLTAGE, 24.0); %outside fan always at 24v
            obj.setRegister(obj.R_FAN2_LSPEED_VOLTAGE, 24.0);
            
            obj.startRegulation;
            obj.controlState = obj.COOLDOWN2EMBIANT;
        end
        
        
        function startMonitoring(obj)
            if obj.monitoringIsRunning; return ;end
            
            obj.monitoringBuffer = obj.createBuffer(10000, 5000, 1);
            obj.monitoringTimer = timer('Period',1, 'ExecutionMode','fixedSpacing',...
                                        'TasksToExecute',24*3600);
                                        
            obj.monitoringTimer.TimerFcn = @obj.updateMonitoring;
            obj.monitoringIsRunning = 1; 
            
            start(obj.monitoringTimer);
            fig = figure(99); clf;
            fig.Position = [1248 69 670 905];
            
        end
        
        function updateMonitoring(obj, varargin)
            
            obj.updateBuffer(obj.monitoringBuffer);
            
           
            if obj.monitoringBuffer.index<1; return ;end
            time = obj.monitoringBuffer.get('time');
            time = (time-time(1))*24*3600;
            
            t1 = obj.monitoringBuffer.get('t1');
            t2 = obj.monitoringBuffer.get('t2');
            t3 = obj.monitoringBuffer.get('t3');
            current = obj.monitoringBuffer.get('current');
            fig = findobj('type','figure','Number',99);
            if isempty(fig)
                fig = figure(99);
                fig.Position = [1248 69 670 905];
            end
            plot(subplot(4,1,1), time,t1);
            ylabel('t1 regul');
            plot(subplot(4,1,2), time,t2);
            ylabel('t2 hot face');
            plot(subplot(4,1,3), time,t3);
            ylabel('t3 cold face');
            plot(subplot(4,1,4), time,current);
            ylabel('current');
            xlabel('time (s)');
        end
        function stopMonitoring(obj)
            obj.monitoringIsRunning = 0;
            if isempty(obj.monitoringTimer) return; end;
            stop(obj.monitoringTimer);
            delete(obj.monitoringTimer);
            obj.monitoringTimer = []; 
        end
        
        function buffer = createBuffer(obj, bufferSize, stepSize, dynamic)
            if nargin <3
                stepSize = 1;
                
            end
            if nargin<4
                dynamic = 0;
            end
            buffer = naomi.TempBuffer(bufferSize, stepSize, dynamic);
            
        end
        
        function updateBuffer(obj, buffer)
            if (buffer.index+1) > buffer.size
                fields = {'t1','t2','t3','current', 'time'};
                nField = length(fields);
               if buffer.dynamic
                   for iField=1:nField
                       field = fields{:};
                       old = buffer.(field);
                       new = zeros(buffer.index+buffer.stepSize, 1);
                       new(1:buffer.index) = old(1:buffer.index);
                       buffer.(field) = new;
                   end
                   
               else
                   for iField=1:nField
                       field = fields{:};
                       buffer.(field)(1:end-buffer.stepSize) = buffer.(field)(buffer.stepSize+1:end);
                   end
                buffer.index = buffer.size - buffer.stepSize;
               end
            end
            
            i = buffer.index +1;
            buffer.t1(i) = obj.getTemp(1);
            buffer.t2(i) = obj.getTemp(2);
            buffer.t3(i) = obj.getTemp(3);
            buffer.current(i) = obj.getCurrent();
            buffer.time(i) = now;
            buffer.index = i;
        end
        
        
        
%         function stopRegulation(obj)
%             fprintf(obj.client, '$Q');
%             fscanf(obj.client); % $Q
%             if ~strcmp('Stop', strip(fscanf(obj.client)))
%                 error('error when stopping regulation');
%             end
%         end
%         
%         function startRegulation(obj)
%             fprintf(obj.client, '$W');
%             fscanf(obj.client); % $W
%             if ~strcmp('Run', strip(fscanf(obj.client)))
%                 error('error when starting regulation');
%             end
%         end
%         function startCooling(obj)
%             % start the bench cooling 
%             obj.setRegister(0,10.0); % temperature 
%             obj.setRegister(10,1.0); % cooling gain
%             obj.setRegister(11,0.0); % heating gain
%             
%             obj.startRegulation;
%         end
%         function startWarmUp(obj)
%             % start the warmup of the bench until embiant temperature
%             embiant = obj.getTemp(obj.EMBIANT);
%             
%             if embiant<=0.0 || embiant>30
%                 % security net, if the embiant temperature is weird set 
%                 % it to 15 degree celcius
%                 embiant = 15;
%             end
%             obj.setRegister(0,embiant); % temperature 
%             obj.setRegister(10,0.0); % cooling gain
%             obj.setRegister(11,0.2); % heating gain
%             
%             obj.startRegulation;
%         end
        function answer = askRegister(obj, registerNumber)
            % stringValue = e.askRegister(num)
            %
            % get the value (in a string) of the given register iddentified 
            % by its number
            % See the Laird documentation for register number definition
             fprintf(obj.client,sprintf('$R%d?', registerNumber));
             fscanf(obj.client);
             answer = fscanf(obj.client);
             
        end
        function setRegister(obj, registerNumber, value)
            % e.setRegister(num, value)
            %
            % set the value inside the register iddentified by its number 
            % See the Laird documentation for register number definition
            fprintf(obj.client,sprintf('$R%d=%.10f', registerNumber, value));
            fscanf(obj.client);
            fscanf(obj.client);
        end
        
        
        function current = getCurrent(obj)
            % current = e.getCurrent()
            % get the applied peltier current 
            current = str2double(obj.askRegister(152));
        end
        
        function current = current(obj)
            current = obj.getCurrent();
        end
        
        function voltage=getFanVoltage(obj, fanNumber)
            % voltage = e.getFanVoltage(number)
            % get the fan voltage. The fan is iddentified by its number:
            % 1. The cold face fan 
            % 2. the hot face fan 
            fanIds = {107,108};
            voltage = str2double(obj.askRegister(fanIds{fanNumber}));
        end
        function voltage=fan1(obj)
            voltage = obj.getFanVoltage(1);
        end
        function voltage=fan2(obj)
            voltage = obj.getFanVoltage(2);
        end
        
        function temp=getTemp(obj, tid)
            % temp = e.getTemp(tid)
            % get the temperature of the sensor defined by its numerical ID
            % the ID should be from 1 to 6 
            %
            % 1. Regulation Temperature  (cold face of peltier)
            % 2. Hot face of Peltier 
            % 3. Not used 
            % 4. Environment temperature (USB temp)
            % 5. USB temp of the mirror
            % 6. USB temp of the QCM mount
            switch tid
                case obj.REGULTEMP
                    temp = str2double(obj.askRegister(100));
                case obj.HOTFACE
                    temp = str2double(obj.askRegister(101));
                case 3
                    temp = str2double(obj.askRegister(102));
                case obj.EMBIANT
                    temp = getUSBTemp(0);
                case obj.MIRROR
                    temp = getUSBTemp(1);
                case obj.QSM
                    temp = getUSBTemp(2);
                otherwise
                    error('Temperature sensor number must be from 1 to 6 got %d', tid);
            end
        end
        
        function temp=temp1(obj)
            temp = obj.getTemp(1);
            
        end
        function temp=temp2(obj)
            temp = obj.getTemp(2);
           
        end
        function temp=temp3(obj)
            temp = obj.getTemp(3);
        end
        function temp=temp4(obj)
            temp = obj.getTemp(4);
        end
        function temp=temp5(obj)
            temp = obj.getTemp(5);
        end
        function temp=temp6(obj)
            temp = obj.getTemp(6);
        end
        
    end
    
end





function temp = getUSBTemp(channelNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    if ~libisloaded('mccFuncLib')
        Temp = 0.0;
    else
        tempVal = 0;
        tempPtr = libpointer('singlePtr', tempVal);
        boardNum = 0 ;% match the board number in InstaCal
        tempScale = 0 ;% 0 = Celsius, 1 = Fahrenheit, 2 = Kelvin, 5 = No Scale
        options = 0; % 0 = Filter, 1024 = No Filter
        
        % appel de la fonction
        calllib('mccFuncLib', 'cbTIn', boardNum, channelNum, tempScale, tempPtr, options);
        
        % lecture de la valeur retourner par le pointeur
        temp = get(tempPtr, 'Value');
    end
end