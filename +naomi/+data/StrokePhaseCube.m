classdef StrokePhaseCube < naomi.data.PhaseCube
	properties
        profileResult; % store the result of a fitted profile
        fitType = 'naomi' % the type of fitting
        biasVector;
        dmCommandArray;
        amplitudeVector;
	end	
	methods
        function obj = StrokePhaseCube(varargin)
            obj = obj@naomi.data.PhaseCube(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'STROKE_PHASE', naomi.KEYS.DPRTYPEc}};
        end
        function data = fitsReadData(obj, fileName)
            % for historical reason anc compatibility with sparta 
            % the data is stored with the last dimension beeing 
            % the actuator number
            
            data = fitsread(fileName);
            data = permute(data, [3,1,2]);
            data = double(data);
            
            obj.dmCommandArray = naomi.readExtention(fileName,'DMCOMMAND',1);
            obj.biasVector = naomi.readExtention(fileName,'DMBIAS',1);
            obj.amplitudeVector = naomi.readExtention(fileName,'AMPLITUDE',1);
            
            if isempty(obj.amplitudeVector)
                error('missing the amplitude vector extention in the fits file');
            end
            
        end
        function zernike = zernike(obj)
            % the stroke zernike number measurement 
            zernike = obj.getKey(naomi.KEYS.ZERN);
        end
        function phaseCube = phaseCube(obj, varargin)
            phaseCube = obj.data;
            if ~isempty(varargin);phaseCube = phaseCube(varargin{:});end
        end
        
        function fitsWriteData(obj, fileName)
            import matlab.io.*
            fitswrite(single(permute(obj.phaseCube, [2,3,1])),fileName);
            if ~isempty(obj.dmCommandArray)
                naomi.saveExtention(obj.dmCommandArray,fileName, 'DMCOMMAND', 1);                
            end
            if ~isempty(obj.biasVector)
                naomi.saveExtention(obj.biasVector,fileName, 'DMBIAS', 1);                
            end
            if ~isempty(obj.amplitudeVector)
                naomi.saveExtention(obj.amplitudeVector,fileName, 'AMPLITUDE', 1);              
            end            
        end
        
        function maxCommandVector = maxCommandVector(obj)
					  maxCommandVector = max(abs(obj.biasVector' + obj.dmCommandArray),[], 2);
						
        end
        
        function  theoreticalPhaseArray = theoreticalPhaseArray(obj, varargin)
            % get the parameters of the used Z2C 
            [pupDiam, cObs, xCenter, yCenter] = obj.ztcMaskParameters;
            orientation = obj.getKey(naomi.KEYS.ORIENT,naomi.KEYS.ORIENTd);
            theoreticalPhaseArray =  naomi.compute.theoriticalPhase(obj.nSubAperture, xCenter, yCenter, pupDiam, cObs, obj.zernike,orientation);
            
            if ~isempty(varargin);  theoreticalPhaseArray =  theoreticalPhaseArray(varargin{:}); end
        end
        
        function theoreticalPhaseCube = theoreticalPhaseCube(obj, varargin)
           theoreticalPhaseArray  = obj.theoreticalPhaseArray;
           theoreticalPhaseCube = zeros(obj.nPhase, obj.nSubAperture, obj.nSubAperture);
           for iPhase=1:obj.nPhase
               theoreticalPhaseCube(iPhase,:,:) = theoreticalPhaseArray*obj.amplitudeVector(iPhase);
           end
            if ~isempty(varargin);  theoreticalPhaseCube =  theoreticalPhaseCube(varargin{:}); end
        end
        
        function rmsVector = rmsVector(obj,  varargin)
            % the rms with tiptilt removed for all phases in the phase cube with lenght of nPhase
            % however do not remove tip/tilt for piston, tip and tilt e.i
            % zernike<4
            if obj.zernike<4
                rmsVector = naomi.compute.nanstd(reshape(obj.phaseCube, obj.nPhase, []), 2);
            else
                 rmsVector = naomi.compute.rms_tt(reshape(obj.phaseCube, obj.nPhase, []), 2);
            end
            if ~isempty(varargin)
                rmsVector = rmsVector(varargin{:});
            end    
        end
          
        function [residualRmsVector, residualP2vVector] = residualRmsVector(obj,varargin)
            residualCube = obj.phaseCube - obj.theoreticalPhaseCube; 
            if obj.zernike<4
                residualRmsVector = naomi.compute.nanstd(reshape(residualCube, obj.nPhase, []), 2);
            else
                residualRmsVector = naomi.compute.rms_tt(reshape(residualCube, obj.nPhase, []), 2);
            end
            residualP2vVector = max( reshape(residualCube, obj.nPhase, []), [], 2) - min( reshape(residualCube, obj.nPhase, []), [], 2);
             if ~isempty(varargin)
               residualRmsVector  = residualRmsVector(varargin{:});
               residualP2vVector = residualP2vVector(varargin{:});
            end 
        end
        
        function plotQc(obj,axesList)
            if nargin<2
                axesList = {subplot(3,1,1), subplot(3,1,2), subplot(3,1,3)};
            end
            
            ax = axesList{1};
            
            plot(ax, obj.amplitudeVector, obj.p2vVector, 'bO-');
            title(ax, sprintf('Stroke Curve mode %d', obj.zernike));
            ylabel(ax, 'PtV (\mum)');
            grid(ax); grid(ax, 'minor');
            
            ax = axesList{2};
            plot(ax, obj.amplitudeVector, obj.residualRmsVector, 'bO-');
            ylabel(ax, 'Res. (\mum rms)');
            grid(ax); grid(ax, 'minor');
            
            
            ax = axesList{3};
            plot(ax, obj.amplitudeVector, obj.maxCommandVector, 'bO-');
            ylabel(ax, 'Max Command');
            grid(ax); grid(ax, 'minor');
            
            xlabel(ax, 'Requested Amplitude (\mum rms)');
        end
            
        
        
    end
end