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
        function plot(obj, axes)
            if nargin<2; axes= gc;end;
        	phase = obj.data;
            cla(axes); imagesc(axes, phase);

            
            
            tit = 'Phase Reference';
            	
            title(axes, {tit,...
                   sprintf('rms=%.3fum ptv=%.3fum',...
                   naomi.compute.nanstd(phase(:)),...
                   max(phase(:)) - min(phase(:)))});
            xlabel(axes, 'Y   =>+');
            ylabel(axes, '+<=   X');
            colorbar(axes);    
        end
    end
end