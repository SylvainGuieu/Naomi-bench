classdef Phase < naomi.data.BaseData
	properties
	

	end	
	methods
        function obj = Phase(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'PHASE', ''}};
        end

        function plot(obj, axes)
            if nargin<2; axes= gc;end;
        	phase = obj.data;
            cla(axes); imagesc(axes, phase);

            
            if strcmp(obj.getKey('PHASEREF','NO'), 'NO'); tit = 'Phase screen';
            else tit = 'Phase screen - reference'; end;
            	
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