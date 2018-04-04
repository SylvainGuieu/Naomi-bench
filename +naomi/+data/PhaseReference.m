classdef PhaseReference < naomi.data.BaseData
	properties
	
	end	
	methods
        function obj = PhaseReference(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'REF_DUMMY', ''}}
        end
    end
end