classdef GimbalAxis < naomi.objects.BaseObject
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        device;
        zero;
        backlash;
        verbose;
        fast;
        slow;
        axis;
        axisName;
        gain;
        
    end
    
    methods
        function  obj = GimbalAxis(device, axisName, gain, zero)
            if nargin<2; gain = 5000;end;
            if nargin<3; zero = 8.5 ;end;
            
                
            obj.device = device;
            obj.axis = '1';
            obj.axisName = axisName;

            fprintf('Enable closed-loop operation\n');
            obj.device.SVO(obj.axis, 1);
            fprintf('Set speed\n');
            obj.fast = 1.0;
            obj.slow = 0.1;
            obj.setVelocity(obj.fast);
            
            obj.zero = zero;
            obj.backlash = 5e-3;
            obj.verbose = 1;
            obj.gain = gain;
        end
        
         function delete(obj)
            fprintf('Close connection to PI\n');
            obj.device.CloseConnection();
         end
         
         function init(obj)
            % go fast to the NegativeLimit 
            % come back to a little 
            % go slow to the negative limit
            vel = obj.getVelocity();
            obj.setVelocity(obj.fast);
            obj.negativeLimit();
            obj.setVelocity(obj.slow);
            obj.moveDirectTo(obj.device.qTMN('1')+0.5);
            obj.negativeLimit();
            obj.setVelocity(vel);
            % go to the zero position
            obj.moveToZero();
         end
         function negativeLimit(obj)
            
            obj.device.FNL(obj.axis);
            while(0 ~= obj.device.IsMoving(obj.axis)); pause(0.05); end;
        
         end
         
         function positiveLimit(obj)
            obj.device.FPL(obj.axis);
            while(0 ~= obj.device.IsMoving(obj.axis)); pause(0.05); end;
         end
        
         function moveDirectTo(obj, pos)
             % Move to position without backlash and wait until position is
             % reached
              obj.device.MOV(obj.axis, pos);
              while(0 ~= obj.device.IsMoving(obj.axis)); pause(0.05); end;
         end
         function moveBy(obj, relPos)
             pos = obj.getPos();
             obj.moveTo(pos+relPos);
         end
         function moveByArcsec(obj, arcsec)
             obj.moveBy(arcsec/obj.gain);
         end
         function moveToZero(obj)
             obj.moveTo(obj.zero);
         end
         function moveTo(obj, pos)
             %% move to target in a optimized way 
             %% using backlash and using defined velocity
             %% use MoveDirectTo for a non optimized movement 
             vel = obj.getVelocity();
             %% if movement is above 10 second move first to
             %% position with fast speed
             %% 
             posDiff = pos-obj.getPos();
             if abs(posDiff)/vel > 10
                 obj.setVelocity(obj.fast);
                 obj.moveDirectTo(pos-sign(posDiff)*0.5);
             end
             obj.setVelocity(obj.slow);
             if posDiff>0
                obj.moveDirectTo(pos+sign(posDiff)*obj.backlash);
             end
             obj.moveDirectTo(pos);
             obj.setVelocity(vel);
         end
         
         function setVelocities(obj, slow, fast)
             %  obj.setVelocities(slow, fast)
             % Set the slow and fast defined velocity
             % Velocities are in mm/second
             obj.slow = slow;
             obj.fast = fast;
         end
         function [pos] = getPos(obj)
             pos = obj.device.qPOS(obj.axis);             
         end
         
         function setVelocity(obj, velocity)
            obj.device.VEL(obj.axis, velocity);
         end
         
         function [vel] = getVelocity(obj)
             vel = obj.device.qVEL(obj.axis);
          
        end
        function populateHeader(obj, h)
                % populate fits header
                naomi.addToHeader(h, upper(strcat(obj.axisName,'ZERO')), obj.zero,   strcat('Zero position of ',obj.axisName,'motor [mm]'));
                naomi.addToHeader(h, upper(strcat(obj.axisName,'GAIN')), obj.gain,   strcat('Gain of ', obj.axisName,' motor [arcsec/mm]'));
                naomi.addToHeader(h, upper(strcat(obj.axisName,'POS')), obj.getPos,  strcat('position of ', obj.axisName,' when header writing [mm]'));
          end
    end
end         
         