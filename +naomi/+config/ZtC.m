function  success = ZtC(bench, data_or_file)
    % isConfigured = config.ZtC(bench) do nothing return true if configured
    % config.ZtC(bench)   a gui ask the user to fetch a file
	% config.ZtC(bench, filePath) load a IF file as ZtC 
	% config.ZtC(bench, ZtCData)   the ZtC data object is configured
	% config.ZtC(bench, [])  remove the configured ZtC if any
	%
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a Zernique to commande file ZTC_*');
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.ZtC(fullPath);
				
	end

	elseif ischar(data_or_file)
			data =  naomi.data.ZtC(data_or_file);
	
	elseif isempty(data_or_file)
		bench.ZtCData = [];			
		sucess = false;
		bench.config.log('Zernique to Command matrix removed', 2);
		if bench.config.plotVerbose
			bench.config.figure('Zernique to Command'); clf;
		end;
		success = true;
		return 
	else
		data = data_or_file;
	end

	bench.ZtCData = data;
	
	success = true;
	
	if bench.config.plotVerbose
		bench.config.figure('Zernique to Command');
		bench.ZtCData.plot();
	end
	bench.config.log('Zernike to command matrix configured',2);
end