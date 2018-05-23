classdef IFMSparta < naomi.data.IFM
	properties
		
	end	
	methods
        function obj = IFMSparta(varargin)
            obj = obj@naomi.data.IFM(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IFM_SPARTA', ''}};
        end     
    end
end