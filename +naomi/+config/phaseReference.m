function phaseReference(bench, data_or_file)
	% configure the phase reference for the bench 
	% if not given a gui will ask for a file
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a Phase reference REF_DUMMY_*');
		if isequal(file, 0); return; end;
		phaseReferenceFile = fullfile(path, file);
		bench.phaseRefData = naomi.data.PhaseReference(phaseReferenceFile);		
	else
		if ischar(data_or_file)	
			if strcmp(data_or_file, '')				
				bench.phaseRefData = [];
			else
				bench.phaseRefData = naomi.data.PhaseReference(data_or_file);				
			end		
		else			
			bench.phaseRefData = data_or_file;
		end
	end
	
	if bench.config.plotVerbose
		naomi.getFigure('Phase reference');
		bench.phaseRefData.plot();
	end
end



