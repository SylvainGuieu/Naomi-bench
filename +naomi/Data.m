classdef Data < handle
	% structure to record data and environemental bench status
	properties
		data;
		benchTemp;
		mjd;
        
        propDef = {{'benchTemp', 'BETEMP', 'Bench temperature in Kelvin'}};
	end
	methods
		function obj = Data(data, dataType, bench, config)
			if ischar(data) || isstring(data)
				obj.loadFits(data);
			else
				obj.data = data;
				obj.dataType = dataType;
				obj.bench = bench;
                obj.config = config;
				obj.mjd = juliandate(datetime('now'),'modifiedjuliandate');
			end
		end
		function writeFitsHeader(obj, f, lst)
			for i=1:length(lst)
                key = lst(i);
               	switch key
               	case 'benchTemp'
               		fits.writeKey(f, 'BENCHTEMP', obj.benchTemp, 'Bench temperature in Kelvin');
               	case 'mjd'
               		fits.writeKey(f, 'MJD-OBS', obj.mjd, 'Modified Julian Date of date taking');
               	case 'dataType'
               		fits.writeKey(f, 'DATATYPE', obj.dataType, 'Data type');
               	end
            end
        end
        function loaded = loadFitsHeader(obj,f)
        	keyCells = f.keywords; % to be defined\
            loaded = {}
        	for i=1:length(keyCells)
        		c = keyCells{i};
        		key = c{1};
        		value = c{2};
                toload = true;
                switch 
                    case 'BENCHTEMP'
                        obj.benchTemp = value;
                    case 'MJD-OBS'
                        obj.mjd = value;
                    case 'DATATYPE'
                        obj.dataType = value;
                    otherwise 
                        toload = false;
                        
                end
                if toload; loaded{length(loaded)+1} = key; end;
            end
        end
        function loadFitsData(obj, filename)
        	obj.data = fitsread(filename)
        end
        function loadFits(obj, filename)
        	f = fits.open(filename);
        	obj.loadFitsData(filename)
        	obj.loadFitsHeader(f);
        	f.close();
        end
	end	
end