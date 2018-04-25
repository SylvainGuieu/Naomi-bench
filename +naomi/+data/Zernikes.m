classdef Zernikes < naomi.data.BaseData
    % handle some plots from a Zernike number only 
	properties
        nSubAperture = 512; % for the phase plot 
        
	end	
	methods
        function obj = Zernikes(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'ZERNIKES', ''}};
        end
        
        function plot(obj, axes)
            if nargin<2; axes = gca; end
            
            bar(axes, obj.data);
            xlabel(axes, 'Zernikes');
            ylabel(axes, 'Amp \mu m rms');
            maxZ = max(abs(obj.data));
            ylim(axes, [-maxZ, maxZ]);
        end
    end
end