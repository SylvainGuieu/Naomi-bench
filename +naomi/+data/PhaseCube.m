classdef PhaseCube < naomi.data.BaseData
	properties
	

	end	
	methods
        function obj = PhaseCube(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'PHASE_CUBE', ''}};
        end

        function plot(obj)
        	% TODO phase cube plot
        end

    end
end