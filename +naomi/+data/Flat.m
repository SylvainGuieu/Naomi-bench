classdef Flat < naomi.data.Phase
	properties
	
	end	
	methods
        function obj = Flatvarargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'FLATO', ''}};
        end
        function plot(obj, axes)
            if nargin<2; axes=gca; end;
        	phase = obj.data;
            cla(axes); imagesc(axes, phase);
            
            if strcmp(obj.getKey('LOOP', 'OPEN', 'OPEN'))
            	ttl = 'Open Loop Flat';
            else
            	ttl = 'Close Loop Flat';
            end	
            	
            title(axes, {ttl,...
                   sprintf('rms=%.3fum ptv=%.3fum',...
                   naomi.compute.nanstd(phase(:)),...
                   max(phase(:)) - min(phase(:)))});
            xlabel(axes, 'Y   =>+');
            ylabel(axes, '+<=   X');
            colorbar(axes);    
        end     	   
    end
end