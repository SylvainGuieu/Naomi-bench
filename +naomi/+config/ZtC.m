function  isConfigured = ZtC(bench, data_or_file)
    % isConfigured = config.ZtC(bench) do nothing return true if configured
	% config.ZtC(bench, filePath) load a IF file as ZtC 
	% config.ZtC(bench, 'fetch')   a gui ask the user to fetch a file
	% config.ZtC(bench, 'measure') the ZtC is measured and configured
	% config.ZtC(bench, 'compute') the ZtC is computed from a previously configured IFM
	% config.ZtC(bench, ZtCData)   the ZtC data object is configured
	% config.ZtC(bench, [])  remove the configured ZtC if any
	%
		
	if nargin<2
		isConfigured = ~isempty(bench.ZtCData);
		return 
	end

	if ischar(data_or_file)
		switch data_or_file
		case 'fetch'
			[file, path] = naomi.askFitsFile('Select a Zernique to commande file ZTC_*');
			if isequal(file, 0); return; end;
			fullPath = fullfile(path, file);
			data = naomi.data.ZtC(fullPath);
		case 'measure'
			[IFMData, IFMCleanData] = naomi.measure.IFM(bench);
			data = naomi.make.ZtC(bench, IFMCleanData);
		case 'compute' % this uspose the the IFM has been loaded or measured
			data = naomi.make.ZtC(bench);
		otherwise % this is a file path
			data =  naomi.data.ZtC(data_or_file);
		end
	else
		if isempty(data_or_file)
			bench.ZtCData = [];			
			isConfigured = false;
			bench.config.log('Zernique to Command matrix removed', 2);
			return 
		else
			data = data_or_file;
	end

	bench.ZtCData = data;
		
	isConfigured = true;
	
	if bench.config.plotVerbose
		bench.config.figure('Zernique to Command');
		bench.ZtCData.plot();
	end
	bench.config.log('Zernike to command matrix configured',2);
end