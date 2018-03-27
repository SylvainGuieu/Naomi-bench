% addpath('C:\Users\Public\PI\PI_MATLAB_Driver_GCS2');
classdef Gimbal < naomi.objects.BaseObject
    properties
        devices;
        backlash;
        daisyChain;
        rX;
        rY;
        N;
            
        
    end 
    
    methods       
        function  obj = Gimbal(ID)
           Controller = PI_GCS_Controller();
           daisyChain = Controller.OpenUSBDaisyChain(ID);
           %% gain computed for X and Y axis are 
           %% 3.3 arcsec per mumeter for X and 5.0 arcsec per memeter for Y
           %% arcsec mecanic
           rY = naomi.objects.GimbalAxis(daisyChain.ConnectDaisyChainDevice(1), 'rY', 5000, 8.5);
           rX = naomi.objects.GimbalAxis(daisyChain.ConnectDaisyChainDevice(2), 'rX', 3300, 8.5);
           
           obj.rX = rX;
           obj.rY = rY;
           obj.daisyChain = daisyChain;
           obj.N = 2;
        end
        function setGains(obj, rXGain, rYGain)
            obj.rX.gain = rXGain;
            obj.rY.gain = rYGain;
            
        end
        function init(obj)
            obj.rX.init();
            obj.rY.init();
        end
        function setVelocity(obj, velocity)
            % set the velocity of both axis
            obj.rX.setVelocity(velocity);
            obj.rY.setVelocity(velocity);
        end
        function setVelocities(obj, slow, fast)
            % set the slow/fast velocity on both axis
            obj.rX.setVelocities(slow, fast);
            obj.rY.setVelocities(slow, fast);
        end
        function moveToZero(obj)
            obj.rX.moveToZero();
            obj.rY.moveToZero();
        end
          function delete(obj)
                fprintf('Close connection to PI\n');
                obj.rX.device.CloseConnection();
                obj.rY.device.CloseConnection();
                obj.daisyChain.CloseDaisyChain();
          end
          function populateHeader(obj, h)
                % populate fits header
                obj.rX.populateHeader(h);
                obj.rY.populateHeader(h);
          end
    end
end