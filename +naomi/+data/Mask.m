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
	    function plot(obj, axes)
            if nargin<2; axes = gca; end
        	mask = obj.data;
            cla(axes); imagesc(axes,mask);                       		
            title(axes, 'Phase Mask');
            xlabel(axes, 'Y   =>+');
            ylabel(axes, '+<=   X');
        end
    end
end