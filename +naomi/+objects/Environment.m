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
        % GOTOCALIB mode when starting the cooldown (or warmup depending of
        % the embiant temperature). Shoud result to the MAINTAIN mode 
        GOTOCALIB = 1; 
        % GOTOEMBIANT to reach embiant temperature. Show result to OFF
        GOTOEMBIANT = 2; 
        
        % Maintain the bench temperature by adjusting the peltier cold face
        % temperature (at about the calib temperature) with the fan on 
        MAINTAIN = 3;
        
        % Turn off the fan and put the peltier to the calib temperature for
        % calibration 
        CALIB = 4;
        
        % User is taking control of the set point temperature and the fan
        % voltage
        MANUAL = 5;
        
        % temperature control turned off (no lair regulation, no fan)
        OFF = 0;
        
        %% temperature setting *OVERWRITTEN BY CONFIG PARAMETERS*
        % calibTemperature 
        calibTemperature = 10.0 
        
        % acceptable difference of temperature between 
        % mirror and embiant to allow door opening                   
        safeDeltaTemp = 2.0 
        
        % temperature difference forwhich it is acceptable to start calibration
        % abs(e.getTemp(e.MIROR)-e.calibTemperature) < e.calibDeltaTemp               
        calibDeltaTemp = 0.25 % +/- x 
        
        %% Temperature
        % When cooling down (or warming up, depend of the embient temperature)
        % The laird regulation temperature is set as 
        %   Tregul = Tcalib - (Tbench0 - Tcalib) * correctiveFactor 
        % Where Tbench0 is the bench (mirror) temperature when starting
        % cooldwond or warmup.
        goToCalibCorrectiveFactor = 1.0;
        goToEmbiantCorrectiveFactor = 1.0;
        
        % in the same way, To set the regulation temperature the formulae
        % is Tregul = Tcalib - (Tembiant - Tcalib) * correctiveFactor
        maintainCorrectiveFactor = 0.0; 
        
        % also when doing a clibration (= fan off) the factor can be set 
        % Tregul = Tcalib - (Tembiant - Tcalib) * correctiveFactor
        % however it is recommanded to be 0.0 to avoid strong gradiant
        % temperature
        calibCorrectiveFactor = 0.0; 
        
        %% Fan 
        goToCalibFanVoltage = 24.0;
        goToEmbiantFanVoltage = 24.0;
        maintainFanVoltage = 24.0;
        calibFanVoltage = 0.0;
        
        
        %%
        % The delta temperature for which the maintain state will start
        % over the goToCalib state. 
        % if Tregul < Tcalib  the Maintain state will start when 
        % T < (Tcalib + DeltaTemp)
        % if Tregul > Tcalib the Maintain state will start when 
        % T > (Tcalib - DeltaTemp)
        startMaintainDeltaTemp = 0.5; 
        
        % In the same way, if the maintain cannot maintain the temperature
        % the startGoToCalibDeltaTemp gives the temperature for witch we
        % may restart the goToCalib mode
        % if Tembiant > Tcalib: (cool down)
        %  T > (Tcalib + DeltaTemp)
        % if Tembiant < Tcali 
        %  T < (Tcalib - DeltaTemp)
        startGoToCalibDeltaTemp = 1.0
        
        %% Constants
        % temperature IDs constant 
        % they are the matlab constant id to recognize temperature 
        S_IN = 1;
        S_OUT = 2;
        S_EMBIANT = 4;
        S_MIRROR = 5;
        S_QSM = 6;
        
        
        % associate peltier temperature to its number
        P_IN = 1;
        P_OUT = 2;
        
        
        % FAN number constant 
        F_IN  = 1;
        F_OUT = 2;
        
        % some input registration numbers
        R_REGUL = 0;
        R_COOLGAIN = 10;
        R_WARMGAIN = 11;
        
        R_FANVOLTAGE = [107 108];
        R_FAN_MODE = [16 23];
        R_FAN_LSPEED_VOLTAGE = [21 28];
        R_FAN_HSPEED_VOLTAGE = [22 29];
        

        R_TEMP = [100 101 102];
        
        R_CURRENT = 152;
        
        ALLWAYSON = 1;
        ALLWAYSOFF = 0;
        
        % usb temp channels  
        U_EMBIANT = 0;
        U_MIRROR = 2;
        U_QSM = 4;
    end
    
    methods (Access = public)
        %%
        % Object handling all the read/write environement parameter of the bench
        % 
        % - temperatures
        %     red by the Peltier Laird-ETS-PR-59 (serial link)
        %     red by the USB-Temp of Measurement Computing (constructor
        %     library) 
        % - control and read the fan voltage (Laird) 
        % - control and read the set point of the Peltier (Laird)
        %
        %  To read temperature 
        %    By their id number 
        %     >>> e.getTemp(3) 
        %    By their name 
        %     >>> e.tmpMirror
        %  
        %  To read fan voltage 
        %     >>> e.getFanVoltage(1) % 1 or 2 
        %     >>> e.fanIn   % innner fan
        %     >>> e.fanOut  % outer fan 
        %
        %  The conrol of temperature is limited by 4 modes which can be set
        %  by these commands  
        %     e.goToCalib()
        %          go Actively to the calibration temperature the set point
        %          of the inner face of Peltier is set to a lower value
        %          than the calibration temperature 
        %     e.maintain()
        %          Maintain the temperature to the calibration temperature
        %          with the Fan On 
        %     e.calib()
        %          (try to) Maintain the temperature with the inner fan off
        %          suitable to start calibration.
        %     e.goToEmbiant()
        %          Put the bench to the embiant temperature. Used after
        %          calibration is finished, before opening the door
        %     e.manual(setPoint, fan1Voltage, fan2Voltage)
        %          User can define the setpoint and fan voltages 
        %     e.turnOff()
        %          The regulation is off, no peltier, no fan
        %
        % 
        % A command , e.updateControl() , is used to monitor the current 
        % mode and eventaully switch from one mode to an other : 
        %         - from goToCalib to maintain  if calib temperature
        %         reached 
        %         - from goToEmbiant to off if embiant temperature reached 
        % 
        % Use e.isReadyToCalib to check if conditions are ok for
        % calibration 
        % Use e.isSafeToOpen to check if conditions are ok to open the door
        %  
        function obj = Environment(port)
            if nargin<1
                port = 'com1';
            end
            fprintf('Init connection to Peltier Controler Laird-ETS-PR-59\n');
            obj.client = serial(port);
            % take from the lair manual
            set(obj.client,'BaudRate',115200);
            set(obj.client,'Parity','none');
            set(obj.client,'StopBits',1);
            set(obj.client,'DataBits',8);
            set(obj.client,'Terminator','CR');
            
            fprintf('Open connection to Peltier Controler Laird-ETS-PR-59\n');
            fopen(obj.client);
            
            obj.verbose = 1;    
            
            fprintf('Load Temperature Sensor library\n');
            % TODO put this to calibration file in a config instead
            loadlibrary C:\MeasurementComputing\DAQ\cbw64.dll C:\MeasurementComputing\DAQ\C\cbw.h alias mccFuncLib;
            
        end
        
        
        function delete(obj)
            fprintf('Close connection to Peltier Controler Laird-ETS-PR-59\n');
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
                case obj.GOTOCALIB
                    test = 0;
                    explanation = 'The bench is still actively trying to reach calibration temperature fans are on';
                    return 
                case obj.MAINTAIN
                    test = 0;
                    explanation = 'The bench is in regulation state -> fans are on';
                    return 
                case obj.GOTOEMBIANT
                    test = 0;
                    explanation = 'The bench is getting to the embiant temperature';
                    return 
            end
            % otherwise check the fan voltage and then the temperature
            fanVoltage = obj.getFanVoltage(obj.F_IN);
            if abs(fanVoltage-obj.calibFanVoltage)>1e-1
                test = 0;
                explanation = sprintf('The Fan inside the bench is still on : voltage = %.2f', fanVoltage);
                return 
            end
            
            tm = obj.getTemp(obj.S_MIRROR);
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
           dt = obj.getTemp(obj.S_EMBIANT) - obj.getTemp(obj.S_MIRROR);
           if abs(dt) < obj.safeDeltaTemp
               test = 1;
           else
               test = 0;
               explanation = sprintf('The difference between bench temperature and embiand temperature is to high: %.2f', dt);
           end
        end
        
        
        function updateControl(obj)
            % e.updateControl()
            % 
            % check the current control mstate (goToCalib, maintain, calib,
            % goToEmbiant, manual or off) and eventually change the control
            % state in some conditions : 
            % 
            %  - switch from goToCalib to maintain  if calib temperature
            %     reached 
            %  - switch from goToEmbiant to off if embiant temperature reached 
            state = obj.controlState;
            
            temp = obj.getTemp(obj.S_MIRROR); % temperature of the mirror
            regulTemp = obj.tempRegul;
            embiantTemp = obj.getTemp(obj.S_EMBIANT);
            calibTemp = obj.calibTemperature;
            switch state
                case obj.MAINTAIN % regulation to maintain the bench temperature
                    % We need to change the state when temperature is
                    % reaching a treshold
                    if embiantTemp>calibTemp % we are cooling down
                        if temp > (calibTemp+obj.startGoToCalibDeltaTemp)
                            obj.goToCalib();
                        end
                    else % we are warming up
                        if temp < (calibTemp - obj.startGoToCalibDeltaTemp)
                            obj.goToCalib();
                        end
                    end
                   
                case obj.GOTOCALIB 
                    if regulTemp < calibTemp % we are cooling down 
                        if temp < (calibTemp+ obj.startMaintainDeltaTemp)
                            obj.maintain();
                        end
                    else % we are warming up
                        if temp > (calibTemp + obj.startMaintainDeltaTemp)
                            obj.maintain();
                        end
                    end
                    
                case obj.GOTOEMBIANT
                    % turn everything off when the embiant temperature is
                    % reached.
                    if temp>= embiantTemp
                        obj.turnOff();
                    end
            end
            
            if ~isempty(obj.controlCallback)
                obj.controlCallback(obj);
            end
        end
        
        function goTo(obj, refTempName, targetTemp, gain, fanIn, fanOut)
            % goTo(obj, refTempName, targetTemp, gain, fanIn, fanOut)
            %
            % Set the set point temperature as :
            % regulTemp = targetTemp - (refTemp-targetTemp) * gain;
            % and the fan voltages 
            % 
            % refTempName is the name used to extract the  refTemp 
            % it can be 'embiant', 'mirror' or 'qsm'
            switch refTempName
                case 'embiant'
                    refTemp = obj.getTemp(obj.S_EMBIANT);
                case 'mirror'
                    refTemp = obj.getTemp(obj.S_MIRROR);
                case 'qsm'
                    refTemp = obj.getTemp(obj.S_QSM);
                otherwise
                    error('reference temp not understood');
            end         
            regulTemp = targetTemp - (refTemp-targetTemp) * gain;
            
            obj.setRegister(obj.R_REGUL, regulTemp);
            obj.setRegister(obj.R_FAN_MODE(obj.F_IN), obj.ALLWAYSON); 
                        
            obj.setRegister(obj.R_FAN_HSPEED_VOLTAGE(obj.F_IN), fanIn); 
            obj.setRegister(obj.R_FAN_LSPEED_VOLTAGE(obj.F_IN), fanIn); 
            
            obj.setRegister(obj.R_FAN_MODE(obj.F_OUT), obj.ALLWAYSON); 
            
            obj.setRegister(obj.R_FAN_HSPEED_VOLTAGE(obj.F_OUT), fanOut);
            obj.setRegister(obj.R_FAN_LSPEED_VOLTAGE(obj.F_OUT), fanOut); 
            
            obj.startRegulation;
        end
        
        function goToCalib(obj)
            % e.goToCalib()
            % Go to the calibration temperature as fast as possible 
            % This mode can result in a temperature lower tha the calibration 
            % temprature. It is expected that user use e.maintain when the
            % calib temperature is reached or use e.controlUpdate() regulary to do
            % it manualy. 
            obj.goTo('mirror', obj.calibTemperature, obj.goToCalibCorrectiveFactor, ...
                obj.goToCalibFanVoltage, 24.0);
            
            obj.controlState = obj.GOTOCALIB;
        end
        function goToEmbiant(obj)
            % e.goToEmbiant()
            % Go to the embiant temperature with higher set point 
            % This mode can result in a higher temperature inside the
            % bench.
            % It is expected that user use e.turnOff() or that e.controlUpdate()
            % is ran regulary. 
            obj.goTo('mirror', obj.getTemp(obj.S_EMBIANT), obj.goToEmbiantCorrectiveFactor, ...
                obj.goToEmbiantFanVoltage, 24.0);
            obj.controlState = obj.GOTOEMBIANT;
        end
        
        function maintain(obj)
            % maintain the temperature inside the bench with the fan on 
            % used by e.controlUpdate() to wait the user to be ready to
            % change the mode to e.calib
            obj.goTo('embiant', obj.calibTemperature, obj.maintainCorrectiveFactor, ...
                obj.maintainFanVoltage, 24.0);
            obj.controlState = obj.MAINTAIN;
        end
        function calib(obj)
            % maintain the temperature inside the bench with the fan OFF 
            % suitable for DM calibration. 
            % The temperature of the inside face of the peltier is set
            % close to the mirror temperature to avoid temp leaks and to 
            % avoid temperature gradiant (turbulences) 
            obj.goTo('embiant', obj.calibTemperature, obj.calibCorrectiveFactor, ...
                obj.calibFanVoltage,  obj.calibFanVoltage);
            obj.controlState = obj.CALIB;
        end
        
        function [tempRegul, fanIn, fanOut] = manual(obj, tempRegul, fanIn, fanOut)
            % turn the control to manual and set the set point regulation temperature 
            % and fan voltages to the given values
            if nargin<2
                tempRegul = obj.tempRegul;
            end
            if nargin<3
                fanIn = obj.fanIn;
            end
            if nargin<4
                fanOut = obj.fanOut;
            end
            
            
%             if fanIn
%                 obj.setRegister(obj.R_FAN_MODE(obj.F_IN), obj.ALLWAYSON); 
%             else
%                 obj.setRegister(obj.R_FAN_MODE(obj.F_IN), obj.ALLWAYSOFF); 
%             end
%             if fanOut
%                 obj.setRegister(obj.R_FAN_MODE(obj.F_OUT), obj.ALLWAYSON); 
%             else
%                 obj.setRegister(obj.R_FAN_MODE(obj.F_OUT), obj.ALLWAYSOFF); 
%             end
            %obj.stopRegulation;
            obj.setRegister(obj.R_FAN_HSPEED_VOLTAGE(obj.F_IN), fanIn); 
            obj.setRegister(obj.R_FAN_LSPEED_VOLTAGE(obj.F_IN), fanIn); 
            obj.setRegister(obj.R_FAN_HSPEED_VOLTAGE(obj.F_OUT), fanOut); 
            obj.setRegister(obj.R_FAN_LSPEED_VOLTAGE(obj.F_OUT), fanOut); 
            obj.setRegister(obj.R_REGUL, tempRegul);
            obj.startRegulation;
            obj.controlState = obj.MANUAL;    
        end
        
        function turnOff(obj)
            % turn the laird off : no peltier,  no fans
            obj.stopRegulation;
            obj.controlState = obj.OFF;
        end
        

        function buffer = createBuffer(obj, bufferSize, stepSize, dynamic)
            % create a buffer used to monitorate the enviroment main
            % parameters.
            %
            % Parameters
            % ----------
            %  bufferSize : initial length of the buffer (default 1000) 
            %  stepSize   : the step size to increase or slide the buffer
            %  (default100)
            % dynamic : 1/0  1: the buffer increase when it reach the end 
            %                0: the first stepSize values are removed to
            %                leave space for the next stepSize values
            if nargin <2
                bufferSize = 1000; 
                stepSize = 100;     
                dynamic = 0;
            elseif nargin <3
                stepSize = int32(bufferSize/4);  
                dynamic = 0;
            elseif nargin<4
                dynamic = 0;
            end
            buffer = naomi.objects.EnvironmentBuffer(bufferSize, stepSize, dynamic);            
        end
        
        function stopRegulation(obj)
            % stop regulation use e.turnOff instead
            fprintf(obj.client, '$Q');
            fscanf(obj.client); % $Q
            if ~strcmp('Stop', strip(fscanf(obj.client)))
                error('error when stopping regulation');
            end
        end
        
        function startRegulation(obj)
            % start regulation use one of e.goToCalib , e.goToEmbiant,
            % e.maintain, e.calib, e.manual instead
            fprintf(obj.client, '$W');
            fscanf(obj.client); % $W
            if ~strcmp('Run', strip(fscanf(obj.client)))
                error('error when starting regulation');
            end
        end
        
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
            current = str2double(obj.askRegister(obj.R_CURRENT));
        end
        
        function current = current(obj)
            current = obj.getCurrent();
        end
        
        function voltage=getFanVoltage(obj, fanNumber)
            % voltage = e.getFanVoltage(number)
            % get the fan voltage. The fan is iddentified by its number:            
            voltage = str2double(obj.askRegister(obj.R_FANVOLTAGE(fanNumber)));
        end
        function voltage=fanIn(obj)
            % inner fan voltage
            voltage = obj.getFanVoltage(obj.F_IN);
        end
        function voltage=fanOut(obj)
            % outer fan voltage
            voltage = obj.getFanVoltage(obj.F_OUT);
        end
        
        function temp = getUSBTemp(obj, usbTempId)
            temp = getUSBTemp(usbTempId);
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
                case obj.S_IN
                    temp = str2double(obj.askRegister(obj.R_TEMP(obj.P_IN)));
                case obj.S_OUT
                    temp = str2double(obj.askRegister(obj.R_TEMP(obj.P_OUT)));
                case 3
                    temp = str2double(obj.askRegister(obj.R_TEMP(3)));
                case obj.S_EMBIANT
                    temp = obj.getUSBTemp(obj.U_EMBIANT);
                case obj.S_MIRROR
                    temp = obj.getUSBTemp(obj.U_MIRROR);
                case obj.S_QSM
                    temp = obj.getUSBTemp(obj.U_QSM);
                otherwise
                    error('Temperature sensor number must be from 1 to 6 got %d', tid);
            end
        end
        function temp = tempRegul(obj)
            % regulation temperature set inside the Laird
            temp = str2double(obj.askRegister(obj.R_REGUL));
        end
        function temp=tempIn(obj)
            % temperature of the inner side of the pletier 
            temp = obj.getTemp(obj.S_IN);
        end
        function temp=tempOut(obj)
            % temperature of the outer side of the pletier 
            temp = obj.getTemp(obj.S_OUT);
        end
        function temp=tempMirror(obj)
            % temperature of the mirror 
            temp = obj.getTemp(obj.S_MIRROR);
        end
        function temp=tempEmbiant(obj)
            % temperature of the mirror 
            temp = obj.getTemp(obj.S_EMBIANT);
        end
        function temp=tempQSM(obj)
            % temperature of the qsm (gimbal base)  
            temp = obj.getTemp(obj.S_QSM);
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