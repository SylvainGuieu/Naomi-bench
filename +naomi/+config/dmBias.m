function  success = dmBias(bench, data_or_file)
    % isConfigured = config.dmBias(bench) do nothing return true if configured
    % config.dmBias(bench)   a gui ask the user to fetch a file
	% config.dmBias(bench, filePath) load a IF file as bias 
	% config.dmBias(bench, dmBiasData)   the bias data object is configured
	% config.dmBias(bench, [])  remove the configured bias if any
	%
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a DM Bias file BIAS_*', bench);
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.DmBias(fullPath);
				
	
	elseif ischar(data_or_file)
			data =  naomi.data.DmBias(data_or_file);
	
	elseif isempty(data_or_file)
		bench.dmBiasData = [];			
		sucess = false;
		bench.log('NOTICE: DM Bias removed', 2);
		
		success = true;
		return 
	else
		data = data_or_file;
    end
    
    % this will change the bench.dm.biasVector
	bench.dmBiasData = data;
	
	success = true;
	
	bench.log('NOTICE: DM Bias configured',2);
end