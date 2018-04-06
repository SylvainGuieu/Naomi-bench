function isConfigured = IFC(bench, data_or_file)
	% isConfigured = config.IFC(bench) do nothing return true if configured
	% config.IFC(bench, filePath) load a IF file as IFC 
	% config.IFC(bench, 'fetch')   a gui ask the user to fetch a file
	% config.IFC(bench, 'measure') the IFC is measured and configured
	% config.IFC(bench, IFCData)   the IFC data object is configured
	% config.IFC(bench, [])  remove the configured IFC if any
	%
	% The IFC will also update the xCenter, yCenter of the bench
	% 
		
	if nargin<2
		isConfigured = ~isempty(bench.IFCData);
		return 
	end

	if ischar(data_or_file)
		switch data_or_file
		case 'fetch'
			[file, path] = naomi.askFitsFile('Select a central actuator phase IFC_*');
			if isequal(file, 0); return; end;
			fullPath = fullfile(path, file);
			data = naomi.data.IF(fullPath);
		case 'measure'
			data = naomi.measure.IF(bench);
		otherwise % this is a file path
			data =  naomi.data.IF(data_or_file);
		end

	else
		if isempty(data_or_file)
			bench.IFC = [];
			bench.xCenter = [];
			bench,yCenter = [];
			isConfigured = false;
			return 
		else
			data = data_or_file;
	end

	bench.IFCData = data;
	[xCenter,yCenter] = naomi.compute.IFCenter(data);
	bench.xCenter = xCenter;
	bench.yCenter = yCenter;
	isConfigured = true;

	if bench.config.plotVerbose
		bench.config.figure('IF Central Actuator');% do not modify name for good placement 
		bench.IFCData.plot();
	end	
	bench.config.log(sprintf('IFCenter and xCenter=%.2f, yCenter=%.2f has been configured ', xCenter, yCenter),2);
end
