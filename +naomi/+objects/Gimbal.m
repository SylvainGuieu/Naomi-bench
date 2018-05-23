% addpath('C:\Users\Public\PI\PI_MATLAB_Driver_GCS2');
classdef Gimbal < naomi.objects.BaseObject
    properties
        devices;
        backlash;
        daisyChain;
        rX;
        rY;
        N;
        serialNumber = -99;
    
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
        function pos = getPos(obj, axis)
            pos = obj.(axis).getPos();
        end
        function moveDirecTo(obj, axis, position)
            obj.(axis).moveDirectTo(position);
        end
        function moveTo(obj, axis, position)
            obj.(axis).moveTo(position);
        end
        function moveBy(obj, axis, relPos)
            obj.(axis).moveBy(relPos);
        end
        function moveByArcsec(obj, axis, arcsec)
            obj.(axis).moveByArcsec(arcsec);
        end
        
        function init(obj, axis)
            if nargin<2
                obj.rX.init();
                obj.rY.init();
            else
                obj.(axis).init();
            end
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
        function moveToZero(obj, axis)
            if nargin<2
                obj.rX.moveToZero();
                obj.rY.moveToZero();
            else
                obj.(axis).moveToZero();
            end
        end
          
          function delete(obj)
                fprintf('Close connection to PI\n');
                obj.rX.device.CloseConnection();
                obj.rY.device.CloseConnection();
                obj.daisyChain.CloseDaisyChain();
          end
          function populateHeader(obj, h)
                % populate fits header
                K = naomi.KEYS;
                naomi.addToHeader(h,  K.GBID, obj.serialNumber,  K.GBIDc);
                obj.rX.populateHeader(h);
                obj.rY.populateHeader(h);
          end
    end
end