function  success = ZtC(bench, data_or_file)
    % isConfigured = config.ZtC(bench) do nothing return true if configured
    % config.ZtC(bench)   a gui ask the user to fetch a file
	% config.ZtC(bench, filePath) load a IF file as ZtC 
	% config.ZtC(bench, ZtCData)   the ZtC data object is configured
	% config.ZtC(bench, [])  remove the configured ZtC if any
	%
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a Zernique to commande file ZTC_*', bench);
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.ZtC(fullPath);
				
	
	elseif ischar(data_or_file)
			data =  naomi.data.ZtC(data_or_file);
	
	elseif isempty(data_or_file)
		bench.ZtCData = [];			
		sucess = false;
		bench.log('NOTICE: Zernique to Command matrix removed', 2);
		
		success = true;
		return 
	else
		data = data_or_file;
	end

	bench.ZtCData = data;
	
	success = true;
	
	
	bench.log('NOTICE: Zernike to command matrix configured',2);
end