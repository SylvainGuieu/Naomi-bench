classdef EnvironmentSimu < naomi.objects.Environment
    
    properties
        simuConnected=0;
        simuRegul = 0;
        simuTime = 0;
        simuRegister;
        simuUSBTemp = [20.0 20.0 20.0 20.0 20.0 50.0 50.0];
        
        % simuTimeScale = 100 -> one 'real' computer second is 100 simulated seconde
        simuTimeScale = 1.0;
        
    end
    
    methods
        function obj = EnvironmentSimu(port, connect)
            obj.simuTime = now;
            obj.simuRegister = containers.Map('KeyType', 'int32', 'ValueType', 'char');
            
            obj.simuRegister(obj.R_REGUL) = '5.0';
            obj.simuRegister(obj.R_TEMP(1)) = '20.0'; % regul = cold peltier
            obj.simuRegister(obj.R_TEMP(2)) = '20.0'; % hot  peltier
            obj.simuRegister(obj.R_TEMP(3)) = '20.0';
            
            obj.simuRegister(obj.R_FANVOLTAGE(1)) = '0.0'; % fan1 voltage
            obj.simuRegister(obj.R_FANVOLTAGE(2)) = '0.0'; % fan2 voltage
            
            obj.simuRegister(obj.R_FAN_HSPEED_VOLTAGE(1)) = '0.0'; % fan1 voltage
            obj.simuRegister(obj.R_FAN_HSPEED_VOLTAGE(2)) = '0.0'; % fan2 voltage
            if nargin<2 || connect; obj.connect(); end
        end
        function connect(obj)
            obj.simuConnected = 1;
        end
        function disconnect(obj)
            obj.simuConnected = 0;
        end
        function test = isConnected(obj)
            test = obj.simuConnected;
        end
        
        function simuUpdate(obj)
          % update the simulated temperature
          
          dTime = (now - obj.simuTime)*24*3600; % delta T in second
          if dTime<0.5
              return 
          end
          dTime = dTime * obj.simuTimeScale;
          
          tErr = 0.2;
          regulTemp = str2double(obj.simuRegister(obj.R_REGUL));
          % peltier cold face
          t1 = str2double(obj.simuRegister(obj.R_TEMP(1)));
          t4 = obj.simuUSBTemp(1); % embient
          
          if obj.simuRegul
              current = (regulTemp-t1)*5.0;
              current = sign(current)* min(2.8, abs(current)); % +/- 2.8 amperes
          else
              current  = 0.0;
          end
          obj.setRegister(obj.R_CURRENT, sprintf('%.6f', current));
          
          leak = 1/60. * 0.01*obj.simuRegul;% deg per second simulate a slow static warmup
          
          % loose 3 degree every 180 minutes current is negative when
          % cooling 
          t1 = max(5.0, t1 + current*dTime/180 + (t4-t1)*leak*dTime )+tErr*(rand-0.5);
          obj.setRegister(obj.R_TEMP(1), sprintf('%.6f', t1)); 
          
          
          t2 = str2double(obj.simuRegister(obj.R_TEMP(2)));
          % loose 3 degree every 180 minutes current is negative when
          % cooling 
          t2 = min(40.0, t2 - current*dTime/180  +  (t4-t2)*leak*dTime )+tErr*(rand-0.5);
          obj.setRegister(obj.R_TEMP(2), sprintf('%.6f', t2));
                    
          % fan 
          fan1 = str2double(obj.simuRegister(obj.R_FAN_HSPEED_VOLTAGE(1))) * obj.simuRegul;
          obj.setRegister(obj.R_FANVOLTAGE(1), sprintf('%.6f', fan1));
          fan2 = str2double(obj.simuRegister(obj.R_FAN_HSPEED_VOLTAGE(2))) * obj.simuRegul;
          obj.setRegister(obj.R_FANVOLTAGE(2), sprintf('%.6f', fan2));
          
          obj.simuUSBTemp(2) = max(8.0, obj.simuUSBTemp(2) + current*dTime/360 + (t4-obj.simuUSBTemp(2))*leak*dTime)+tErr*(rand-0.5);
          
          obj.simuUSBTemp(3) = max(8.0, obj.simuUSBTemp(3) + current*dTime/360 + (t4-obj.simuUSBTemp(3))*leak*dTime)+tErr*(rand-0.5);
          
          obj.simuUSBTemp(1) = 20.0+tErr*(rand-0.5);  % embiant 
           
          obj.simuTime = now;
        end
       
        
        
        function startRegulation(obj)
            obj.simuRegul = 1;            
        end
        function stopRegulation(obj)
            obj.simuRegul = 0;
        end
        function value = askRegister(obj, rId)
            obj.simuUpdate;
            value = obj.simuRegister(rId);
        end
        function setRegister(obj, rId, value)
            if ischar(value) || isstring(value)
                obj.simuRegister(rId) = value;
            else                
                obj.simuRegister(rId) = sprintf('%.10f',value);
            end
        end
        function temp = getUSBTemp(obj, id)
            temp = obj.simuUSBTemp(id+1);
        end
            
        
    end
end

