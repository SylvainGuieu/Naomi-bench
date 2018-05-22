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
        
        function maxCommandVector = maxCommandVector(obj, varargin)
            biasArray 
            maxCommandVector = max(abs(dm.biasVector + dm.cmdVector),2);
        end
        
        function strokeData = strok(obj, phiTarget)
            
        % Get the PtV
	    outputArray(s,3) = max(phiArray(:)) - min(phiArray(:));
        outputArray(s,5) = max(residualArray(:)) - min(residualArray(:));
        
        
        % remove the TT only for tip, tilt and piston
        if nargin<4
            if zernikeMode < 0
                outputArray(s,4) = naomi.compute.nanstd(phiArray(:));
                outputArray(s,6) = naomi.compute.nanstd(residualArray(:));
            else
                outputArray(s,4) = naomi.compute.rms_tt(phiArray);
                outputArray(s,6) = naomi.compute.rms_tt(residualArray);
            end
        else
            residualArray = phiArray - phiTarget.*amplitudeVector(s);
            
            
            
        
        end
        end
        
        
        
    end
end