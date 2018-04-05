classdef PhaseReference < naomi.data.Phase
	properties
	
	end	
	methods
        function obj = PhaseReference(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'REF_DUMMY', ''}};
        end
    end
end