classdef Flat < naomi.data.Phase
	properties
	
	end	
	methods
        function obj = Flat(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'FLATO', naomi.KEYS.DPRTYPEc}};
        end
        function plot(obj, axes)
            if nargin<2; axes=gca; end;
        	phase = obj.data;
            cla(axes); imagesc(axes, phase);
            K = naomi.KEYS;
            switch obj.getKey(K.LOOP, 'OPEN')
                case 'OPEN'
            	 ttl = 'Open Loop Flat';
                otherwise
            	 ttl = 'Close Loop Flat';
            end	
            	
            title(axes, {ttl,...
                   sprintf('rms=%.3fum ptv=%.3fum',...
                   naomi.compute.nanstd(phase(:)),...
                   max(phase(:)) - min(phase(:)))});
            naomi.plot.phaseAxesLabel(axes, obj.getKey(K.ORIENT, K.ORIENTd));            
            colorbar(axes);    
        end     	   
    end
end