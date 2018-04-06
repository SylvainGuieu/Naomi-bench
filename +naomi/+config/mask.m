function isConfigured = mask(bench, data_or_file)
	% isConfigured = config.mask(bench) do nothing return true if configured
	% config.mask(bench, filePath) load a Mask file
	% config.mask(bench, 'fetch')   a gui ask the user to fetch a file
	% config.mask(bench, maskData)   the maskData data object is configured
	% config.mask(bench, [])  remove the mask
	%
	
	if nargin<2
		isConfigured = ~isempty(bench.maskData);
		return 
	end

	if ischar(data_or_file)
		switch data_or_file
		case 'fetch'
			[file, path] = naomi.askFitsFile('Select a mask file MASK_*');
			if isequal(file, 0); return; end;
			fullPath = fullfile(path, file);
			data = naomi.data.Mask(fullPath);		
		otherwise % this is a file path
			data =  naomi.data.Mask(data_or_file);
		end	
	else
		if isempty(data_or_file)
			bench.maskData = [];			
			isConfigured = false;
			bench.config.log('the mask has been removed',2);
			return 
		else
			data = data_or_file;
	end

	bench.maskData= data;	
	isConfigured = true;
		
	if bench.config.plotVerbose
		naomi.getFigure('Phase Mask');
		bench.maskData.plot();
	end	
	bench.config.log('a mask has been configured',2);

end
