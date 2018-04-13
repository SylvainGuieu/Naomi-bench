classdef ZtPSparta < naomi.data.ZtP
	properties
	

	end	
	methods
        function obj = ZtPSparta(varargin)
            obj = obj@naomi.data.ZtP(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ZTP_MATRIX_SPARTA', ''}};
        end
    end
end