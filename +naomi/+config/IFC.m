function success = IFC(bench, data_or_file)
	% isConfigured = config.IFC(bench) do nothing return true if configured
	% config.IFC(bench)  a gui ask the user to fetch a file
	% config.IFC(bench, filePath) load a IF file as IFC 
	% config.IFC(bench, IFCData)   the IFC data object is configured
	% config.IFC(bench, [])  remove the configured IFC if any
	%
	% The IFC will also update the xCenter, yCenter of the bench
	% 
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a central actuator phase IFC_*');
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.IF(fullPath);
	
	elseif ischar(data_or_file)		
			data =  naomi.data.IF(data_or_file);		
	elseif isempty(data_or_file)
		bench.IFC = [];
		bench.measuredCcenter = [];
		bench.measuredYcenter = [];
		if bench.config.plotVerbose
			naomi.plot.figure('IF Central Actuator'); clf;
		end
		success = true;
		return 
	else
		data = data_or_file;
	end

	bench.IFCData = data;
	[xCenter,yCenter] = naomi.compute.IFCenter(data.data);
	bench.measuredXcenter = xCenter;
	bench.measuredYcenter = yCenter;
	success = true;

	if bench.config.plotVerbose
		naomi.plot.figure('IF Central Actuator');% do not modify name for good placement 
		bench.IFCData.plot();
	end	
	bench.log(sprintf('NOTICE: IFC xCenter=%.2f, yCenter=%.2f has been configured ', xCenter, yCenter),2);
end
