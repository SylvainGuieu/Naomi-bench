function  success = bias(bench, data_or_file)
    % isConfigured = config.bias(bench) do nothing return true if configured
    % config.bias(bench)   a gui ask the user to fetch a file
	% config.bias(bench, filePath) load a IF file as bias 
	% config.bias(bench, dmBiasData)   the bias data object is configured
	% config.bias(bench, [])  remove the configured bias if any
	%
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a DM Bias file BIAS_*');
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.dmBias(fullPath);
				
	
	elseif ischar(data_or_file)
			data =  naomi.data.dmBias(data_or_file);
	
	elseif isempty(data_or_file)
		bench.dmBiasData = [];			
		sucess = false;
		bench.config.log('DM Bias removed', 2);
		if bench.config.plotVerbose
			naomi.plot.figure('DM Bias'); clf;
        end
		success = true;
		return 
	else
		data = data_or_file;
    end
    
    % this will change the bench.dm.biasVector
	bench.dmBiasData = data;
	
	success = true;
	
	if bench.config.plotVerbose
		naomi.plot.figure('DM bias');
		bench.dmBiasData.plot();
	end
	bench.config.log('DM Bias  configured',2);
end