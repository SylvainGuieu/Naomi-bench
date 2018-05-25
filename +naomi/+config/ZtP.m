function  success = ZtP(bench, data_or_file)
    % isConfigured = config.ZtP(bench) do nothing return true if configured
    % config.ZtP(bench)   a gui ask the user to fetch a file
	% config.ZtP(bench, filePath) load a IF file as ZtP 
	% config.ZtP(bench, ZtPData)   the ZtP data object is configured
	% config.ZtP(bench, [])  remove the configured ZtP if any
	%
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a Phase to Zernike file ZtP_*', bench);
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.ZtP(fullPath);
				
	
	elseif ischar(data_or_file)
			data =  naomi.data.ZtP(data_or_file);
	
	elseif isempty(data_or_file)
		bench.ZtPData = [];			
		sucess = false;
		bench.log('NOTICE: Phase to Zernike matrix removed', 2);
		
		success = true;
		return 
	else
		data = data_or_file;
	end

	bench.ZtPData = data;
	
	success = true;
	
	
	bench.log('NOTICE: Phase to Zernike matrix configured',2);
end