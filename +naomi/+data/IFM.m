classdef IFM < naomi.data.PhaseCube
	properties
		
	end	
	methods
        function obj = PhaseCube(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'IFM', ''}}
        end
     
    end
end