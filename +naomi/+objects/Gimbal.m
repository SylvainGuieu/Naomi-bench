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
           rY = naomi.objects.GimbalAxis(daisyChain.ConnectDaisyChainDevice(1), 5000, 8.5);
           rX = naomi.objects.GimbalAxis(daisyChain.ConnectDaisyChainDevice(2), 3300, 8.5);
           
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
          function writeFitsHeader(obj, f)
                % populate fits header
                naomi.addToHeader(f, 'RXZERO', obj.rX.zero, 'Zero position of rX motor [mm]');
                naomi.addToHeader(f, 'RYZERO', obj.rY.zero, 'Zero position of rY motor [mm]');
                naomi.addToHeader(f, 'RXGAIN', obj.rX.gain, 'Gain of rX motor [arcsec/mm]');
                naomi.addToHeader(f, 'RYGAIN', obj.rY.gain, 'Gain of rY motor [arcsec/mm]');
                naomi.addToHeader(f, 'RXPOS',  obj.rX.getPos, 'position of rX when header writing [mm]');
                naomi.addToHeader(f, 'RYPOS',  obj.rY.getPos, 'position of rY when header writing [mm]');
          end
    end
end