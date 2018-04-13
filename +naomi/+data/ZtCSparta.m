classdef ZtCSparta < naomi.data.ZtC
	properties
	

	end	
	methods
        function obj = ZtCSparta(varargin)
            obj = obj@naomi.data.ZtC(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ZTC_MATRIX_SPARTA', ''}};
        end        
 	end
end