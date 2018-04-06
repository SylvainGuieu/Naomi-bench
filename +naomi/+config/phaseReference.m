function isConfigured = phaseReference(bench, data_or_file)
	% isConfigured = config.phaseReference(bench) do nothing return true if configured
	% config.phaseReference(bench, filePath) load a phaseReference file
	% config.phaseReference(bench, 'fetch')   a gui ask the user to fetch a file
	% config.phaseReference(bench, 'measure') measure a phase reference and configure it
	% config.phaseReference(bench, phaseReferenceData)   the phaseReferenceData data object is configured
	% config.phaseReference(bench, [])  remove the phaseReference
	%
	
	if nargin<2
		isConfigured = ~isempty(bench.phaseReferenceData);
		return 
	end

	if ischar(data_or_file)
		switch data_or_file
		case 'fetch'
			[file, path] = naomi.askFitsFile('Select a mask file MASK_*');
			if isequal(file, 0); return; end;
			fullPath = fullfile(path, file);
			data = naomi.data.PhaseReference(fullPath);
		case 'measure'
			data = naomi.measure.phaseReference(bench);
		otherwise % this is a file path
			data =  naomi.data.PhaseReference(data_or_file);
		end	
	else
		if isempty(data_or_file)
			bench.phaseReferenceData = [];			
			isConfigured = false;
			bench.config.log('the Phase reference has been removed',2);
			return 
		else
			data = data_or_file;
	end

	bench.phaseReferenceData= data;	
	isConfigured = true;
		
	if bench.config.plotVerbose
		naomi.getFigure('Phase Reference');
		bench.phaseReferenceData.plot();
	end	
	bench.config.log('a Phase reference has been configured',2);

end


