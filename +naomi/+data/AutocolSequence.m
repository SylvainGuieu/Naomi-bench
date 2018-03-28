classdef AutocolSequence< naomi.data.BaseData
	properties
	alphaPlotAxes;
	betaPlotAxes;
    
    TIME_INDEX = 1;
    RX_INDEX = 2;
    RY_INDEX = 3;
    ALPHA_INDEX = 4;
    BETA_INDEX  = 5;
    ERR_ALPHA_INDEX = 6;
    ERR_BETA_INDEX  = 7;

	end	
	methods
        function obj = AutocolSequence(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end

        function append(obj, time, rx, ry, alpha, beta, alpha_err, beta_err)
        	obj.data = [obj.data; [time, rx, ry, alpha, beta, alpha_err, beta_err]];
        end
        function initPlot(obj)      
            fa = naomi.getFigure('autocol Seq alpha');          
            if isempty(fa.Children); obj.alphaPlotAxes = axes(fa);
            else; obj.alphaPlotAxes = fa.Children(1);end
            fb = naomi.getFigure('autocol Seq beta');
            if isempty(fb.Children);  obj.betaPlotAxes = axes(fb);
            else; obj.betaPlotAxes = fb.Children(1);end
        end

        

		function plot(obj)
			if isempty(obj.data); return ;end

			if ~isempty(obj.alphaPlotAxes)
				plot(obj.alphaPlotAxes, obj.data(:,obj.ALPHA_INDEX), 'bo-');
                title(obj.alphaPlotAxes, sprintf('RX = %.3f', obj.getKey('RXPOS',nan)));
                ylabel('alpha [arcsec]');
            end
			if ~isempty(obj.betaPlotAxes)
				plot(obj.betaPlotAxes, obj.data(:,obj.BETA_INDEX),  'bo-');
                title(obj.betaPlotAxes, sprintf('RY = %.3f', obj.getKey('RYPOS',nan)));
                ylabel('beta [arcsec]');
            end
		end
	end
end


