classdef Stroke < naomi.data.BaseData
	properties
	

	end	
	methods
        function obj = Stroke(varargin)
            obj = obj@naomi.data.BaseData(varargin{:});
        end
        function sh = staticHeader(obj)
        	sh = {{'DPR_TYPE', 'STROKE', ''}};
        end

        function plot(obj, axesList)
            if nargin<2; axesList = []; end
            
        	amplitudeVector = obj.data(':',1);
        	maxCommandVector =  obj.data(':',2);
        	ptvVector = obj.data(':',3);
        	rmsVector = obj.data(':',4);
            
            if axesList; ax = axesList{1};
            else
                gcf;
                ax = subplot(3,1,2);
            end
			plot(ax, amplitudeVector,rmsVector,'o-');
			ylabel(ax, 'Res. RMS (um)');
			xlabel(ax, 'Requested Amplitude (um-wavefront RMS)');
			grid(ax); grid(ax, 'minor');
            
            if axesList; ax = axesList{2};
            else
                gcf;
                ax = subplot(3,1,3);
            end
			
			plot(ax, amplitudeVector,maxCommandVector,'o-');
			ylabel(ax, 'Max Command');
			xlabel(ax, 'Requested Amplitude (um-wavefront RMS)');
			grid(ax); grid(ax,'minor');
            
            if axesList; ax = axesList{3};
            else
                gcf;
                ax = subplot(3,1,1);
            end			
			plot(ax, amplitudeVector,ptvVector,'o-');
			ylabel(ax, 'PtV (um)');
			xlabel(ax, 'Requested Amplitude (um-wavefront RMS)');
			grid(ax); grid(ax, 'minor');

			title(ax,sprintf('Stroke curve mode %i',obj.getKey('MODE', -1)));
        end
    end
end