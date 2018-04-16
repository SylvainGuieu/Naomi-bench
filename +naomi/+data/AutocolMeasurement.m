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
        function plotAlpha(obj, axes)
            if nargin<2; axe = gca end;
           
            plot(axes, obj.alpha)
            title(axes, sprintf('%s RX = %.3f', obj.getKey('DATE-OBS',''), obj.getKey('RXPOS',nan)));
            ylabel(axes, 'alpha [arcsec]');
        end
        function plotBeta(obj, axes)
            if nargin<2; axes = gca; end;
            
            plot(axes, obj.beta)
            title(axes, sprintf('%s RY = %.3f', obj.getKey('DATE-OBS',''), obj.getKey('RYPOS',nan)));
            ylabel(axes, 'beta [arcsec]');
        end
        
		function plot(obj, axesList)
            if isempty(obj.data); return ;end
            if nargin<2
                gcf();
                axesList = {
                    subplot(3,1,1);
                    subplot(3,1,2);
                };
            end
            obj.plotAlpha(axesList{1});
            obj.plotBeta(axesList{2});			
		end
	end
end


