classdef PtC < naomi.data.BaseData
	properties
	

	end	
	methods
        function obj = PtC(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
          sh = {{naomi.KEYS.DPRTYPE, 'PTC', naomi.KEYS.DPRTYPEc}};
        end
 	end
end