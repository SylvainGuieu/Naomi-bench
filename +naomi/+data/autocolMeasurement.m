classdef autocolMeasurement < naomi.data.BaseData
	properties
	alphaPlotAxes;
	betaPlotAxes;
	end	
	methods
		function plot(obj)
			if isempty(obj.data); return ;end

			if ~isempty(obj.alphaPlotAxes)
				plot(obj.alphaPlotAxes, obj.data(:,ALPHA_INDEX), 'bo-');
			if ~isempty(obj.betaPlotAxes)
				plot(obj.betaPlotAxes, obj.data(:,BETA_INDEX),  'bo-');
		end
	end
end

ALPHA_INDEX = 1;
BETA_INDEX  = 2;
