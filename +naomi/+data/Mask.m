classdef Mask < naomi.data.Phase
	properties
	

	end	
	methods
        function obj = Mask(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'PHASE_MASK', ''}};
        end
	    function plot(obj)
        	mask = obj.data;
            clf; imagesc(mask);                       		
            title('Phase Mask');
            xlabel('Y   =>+');
            ylabel('+<=   X');
        end
    end
end