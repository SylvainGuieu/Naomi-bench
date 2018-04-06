classdef AutocolMeasurement < naomi.data.BaseData
	properties
	alphaPlotAxes;
	betaPlotAxes;
    ALPHA_INDEX = 1;
    BETA_INDEX  = 2;
   
	end	
	methods
        function obj = AutocolMeasurement(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        %function obj = autocolMeasurement(data)
            %obj.data = data;
            %obj = obj@naomi.data.BaseData(varargin{:});
        %end
        
        function a = alpha(obj);
            a = obj.data(:,obj.ALPHA_INDEX);
        end
        function b = beta(obj);
            b = obj.data(:,obj.BETA_INDEX);
        end
        function plotAlpha(obj, varargin)
            plot(obj.alpha, varargin{:})
            title(sprintf('%s RX = %.3f', obj.getKey('DATE-OBS',''), obj.getKey('RXPOS',nan)));
            ylabel('alpha [arcsec]');
        end
        function plotBeta(obj, varargin)
            plot(obj.beta, varargin{:})
            title(sprintf('%s RY = %.3f', obj.getKey('DATE-OBS',''), obj.getKey('RYPOS',nan)));
            ylabel('beta [arcsec]');
        end
        
		function plot(obj)
			if isempty(obj.data); return ;end
            subplot(3,1,1);
            obj.plotAlpha();
            subplot(3,1,2);
            obj.plotBeta();			
		end
	end
end


