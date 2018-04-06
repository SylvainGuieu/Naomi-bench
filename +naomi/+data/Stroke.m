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

        function plot(obj)

        	amplitudeVector = obj.data(:,1);
        	maxCommandVector =  obj.data(:,2);
        	ptvVector = obj.data(:,3);
        	rmsVector = obj.data(:,4);

        	subplot(3,1,2);
			plot(amplitudeVector,rmsVector,'o-');
			ylabel('Res. RMS (um)');
			xlabel('Requested Amplitude (um-wavefront RMS)');
			grid; grid minor;

			subplot(3,1,3);
			plot(amplitudeVector,maxCommandVector,'o-');
			ylabel('Max Command');
			xlabel('Requested Amplitude (um-wavefront RMS)');
			grid; grid minor;

			subplot(3,1,1);
			plot(amplitudeVector,ptvVector,'o-');
			ylabel('PtV (um)');
			xlabel('Requested Amplitude (um-wavefront RMS)');
			grid; grid minor;

			title(sprintf('Stroke curve mode %i',obj.getKey('MODE', -1)));
        end
    end
end