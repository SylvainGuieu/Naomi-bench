classdef ZtCSparta < naomi.data.ZtC
	properties
	

	end	
	methods
        function obj = ZtCSparta(varargin)
            obj = obj@naomi.data.ZtC(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'M2DM',   naomi.KEYS.DPRTYPEc},...
				  {naomi.KEYS.DPRVER, 'SPARTA', naomi.KEYS.DPRVERc}};
        end   
        function idx = zernike2index(obj, zernike)
            % convert the given zernike number to the table index
            idx = zernike-1;
        end
        function zernike = firstZernike(obj)
            % the first zernike number of the data 
            zernike = 2;
        end
        function zernike = lastZernike(obj)
            [zernike,~] = size(obj.data);
            zernike = zernike+1;
        end
 	end
end