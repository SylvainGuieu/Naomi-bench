function IFC(bench, data_or_file)
	% configure the phase IF for central actuator
	% if not given a gui will ask for a file
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a central actuator phase IFC_*');
		if isequal(file, 0); return; end;
		IFCFile = fullfile(path, file);
		bench.IFCData= naomi.data.PhaseReference(IFCFile);		
	else
		if ischar(data_or_file)	
			if strcmp(data_or_file, '')				
				bench.IFCData = [];
			else
				bench.IFCData = naomi.data.IF(data_or_file);				
			end		
		else			
			bench.IFCData = data_or_file;
		end
	end
	bench.config.log('IFC configured, new xCenter, yCenter computed\n', 1);
	[xCenter,yCenter] = naomi.compute.IFCenter(bench.IFCData.data);
	bench.xCenter = xCenter;
	bench.yCenter = yCenter;
	
	if bench.config.plotVerbose
		naomi.getFigure('IF central actuator');
		bench.IFCData.plot();
	end
end
