classdef PhaseReference < naomi.data.Phase
	properties
	
	end	
	methods
        function obj = PhaseReference(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'WF_REF', naomi.KEYS.DPRTYPEc}};
        end
        function plot(obj, axes)
            if nargin<2; axes= gca;end;
        	phase = obj.data;
            [nSubAperture, ~] = size(phase);
            cla(axes); imagesc(axes, phase);

            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);
            
            tit = 'Phase Reference';
            	
            title(axes, {tit,...
                   sprintf('rms=%.3fum ptv=%.3fum',...
                   naomi.compute.nanstd(phase(:)),...
                   max(phase(:)) - min(phase(:)))});
            naomi.plot.phaseAxesLabel(  axes, obj.getKey(naomi.KEYS.ORIENT, naomi.KEYS.ORIENTd));
            
            colorbar(axes); 
            daspect([1,1,1]); %square
        end
    end
end