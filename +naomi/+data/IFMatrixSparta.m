classdef IFMatrixSparta < naomi.data.IFMatrix
	properties
		
	end	
	methods
        function obj = IFMatrixSparta(varargin)
            obj = obj@naomi.data.IFMatrix(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IFM_SPARTA', ''}};
        end     
    end
end