function  success = IFM(bench, data_or_file)
    % 
    % config.IFM(bench)   a gui ask the user to fetch a file
	% config.IFM(bench, filePath) load a IF file as IFM 
	% config.IFM(bench, IFMData)   the IFM data object is configured
	% config.IFM(bench, [])  remove the configured IFM if any
	%
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a Zernique to commande file ZTC_*');
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.IFMatrix(fullPath);	
	
	elseif ischar(data_or_file)
			data =  naomi.data.IFMatrix(data_or_file);
	
	elseif isempty(data_or_file)
		bench.IFMData = [];			
		success = false;
		bench.config.log('IFM matrix removed', 2);
		if bench.config.plotVerbose
			bench.config.figure('IFM'); clf;
		end;
		success = true;
		return 
	else
		data = data_or_file;
	end

	bench.IFMData = data;
	
	success = true;
	
	if bench.config.plotVerbose
		bench.config.figure('IFM');
		bench.IFMData.plot();
	end
	bench.config.log('IFM matrix configured',2);
end