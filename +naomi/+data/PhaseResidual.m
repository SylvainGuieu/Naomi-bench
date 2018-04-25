classdef PhaseResidual < naomi.data.Phase
	properties
	
	end	
	methods
        function obj = PhaseResidual(varargin)
            obj = obj@naomi.data.Phase(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{naomi.KEYS.DPRTYPE, 'PHASE_RESIDUAL', naomi.KEYS.DPRTYPEc}};
        end
        function plot(obj, axes)
            if nargin<2; axes= gca;end;
        	phase = obj.data;
            [nSubAperture,~] = size(phase);
            cla(axes); imagesc(axes, phase);
            xlim(axes, [1,nSubAperture]);
            ylim(axes, [1,nSubAperture]);
            
            
            tit = 'Residuals';
            	
            title(axes, {tit,...
                   sprintf('rms=%.3fum ptv=%.3fum',...
                   naomi.compute.nanstd(phase(:)),...
                   max(phase(:)) - min(phase(:)))});
            naomi.plot.phaseAxesLabel(  axes, obj.getKey(naomi.KEYS.ORIENT, naomi.KEYS.ORIENTd));
            
            colorbar(axes);            
            daspect(axes, [1,1,1]);
        end
    end
end