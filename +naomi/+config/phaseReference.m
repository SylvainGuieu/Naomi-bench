function success= phaseReference(bench, data_or_file)
	% isConfigured = config.phaseReference(bench) do nothing return true if configured
	% config.phaseReference(bench, filePath) load a phaseReference file
	% config.phaseReference(bench, 'fetch')   a gui ask the user to fetch a file
	% config.phaseReference(bench, 'measure') measure a phase reference and configure it
	% config.phaseReference(bench, phaseReferenceData)   the phaseReferenceData data object is configured
	% config.phaseReference(bench, [])  remove the phaseReference
	%
	success = false;
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a mask file MASK_*', bench);
		if isequal(file, 0); return; end;
		fullPath = fullfile(path, file);
		data = naomi.data.PhaseReference(fullPath);

	elseif ischar(data_or_file)			
			data =  naomi.data.PhaseReference(data_or_file);
		
	elseif isempty(data_or_file)
			bench.phaseReferenceData = [];			
			isConfigured = false;
			success  = true;
			bench.log('NOTICE: The phase reference has been removed',2);
			return 
	else
			data = data_or_file;
	end

	bench.phaseReferenceData = data;	
	success = true;
		
	
	bench.log('NOTICE a new Phase reference has been configured',2);
end


