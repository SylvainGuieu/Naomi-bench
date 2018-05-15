classdef TurbuCube < naomi.data.PhaseCube
	properties
        profileResult; % store the result of a fitted profile
        fitType = 'naomi' % the type of fitting
	end	
	methods
        function obj = TurbuCube(varargin)
            obj = obj@naomi.data.PhaseCube(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'TURBU', ''}};
        end
        function setData(obj, data)
            setData@naomi.data.PhaseCube(obj, data);
            obj.profileResult = []; % empty profiles since data has changed 
        end
        function data = fitsReadData(obj, file)
            % for historical reason anc compatibility with sparta 
            % the data is stored with the last dimension beeing 
            % the actuator number
            data = matlab.io.fits.readImg(file);
            data = permute(data, [3,1,2]);
            data = double(data);
        end
        function fitsWriteData(obj, fileName)
            fitswrite(single(permute(obj.data, [2,3,1])),fileName);
            %matlab.io.fits.writeImg(.file, obj.getData());
        end
        
        function phaseData = phaseData(obj, index)
            phaseData = naomi.data.Phase(squeeze(obj.data(index,:,:)));
        end
        
    end
end