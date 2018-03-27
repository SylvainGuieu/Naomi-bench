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
        
        function initPlot(obj)      
            fa = naomi.getFigure('autocol alpha');          
            if isempty(fa.Children); obj.alphaPlotAxes = axes(fa);
            else; obj.alphaPlotAxes = fa.Children(1);end
            fb = naomi.getFigure('autocol beta');
            if isempty(fb.Children);  obj.betaPlotAxes = axes(fb);
            else; obj.betaPlotAxes = fb.Children(1);end
        end
		function plot(obj)
			if isempty(obj.data); return ;end

			if ~isempty(obj.alphaPlotAxes)
				plot(obj.alphaPlotAxes, obj.data(:,obj.ALPHA_INDEX), 'bo-');
                ylabel('alpha [arcsec]');
            end
			if ~isempty(obj.betaPlotAxes)
				plot(obj.betaPlotAxes, obj.data(:,obj.BETA_INDEX),  'bo-');
                ylabel('beta [arcsec]');
            end
		end
	end
end


