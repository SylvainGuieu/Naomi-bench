function success = mask(bench, data_or_file)
	% config.mask(bench) a gui ask the user to fetch a file
	% config.mask(bench, filePath) load a Mask file
	% config.mask(bench, maskData)   the maskData data object is configured
	% config.mask(bench, [])  remove the mask
	%
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a mask file MASK_*', bench);
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.Mask(fullPath);
		
	elseif ischar(data_or_file)
			data =  naomi.data.Mask(data_or_file);
			
	elseif isempty(data_or_file)
			bench.maskData = [];			
			success = false;
			bench.log('NOTICE: the mask has been removed', 2);
			return 
	else
		data = data_or_file;
	end
	
	bench.maskData= data;
	success = true;
	
	
	bench.log('NOTICE a new mask has been configured',3);
end
