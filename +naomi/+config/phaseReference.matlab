function phaseReference(bench, phaseReferenceFile)
	% configure the phase reference for the bench 
	% if not given a gui will ask for a file 
	if nargin<2
		[file, path] = uigetfile('*.fits', 'Select a Phase reference REF_DUMMY_*');
		if isequal(file, 0); return; end;
		phaseReferenceFile = fullfile(path, file);
		bench.PHASE_REF = naomi.data.PhaseReference(phaseReferenceFile);
		bench.config.phaseReferenceFile = phaseReferenceFile;

	elseif strcmp(phaseReferenceFile, '')
		bench.config.phaseReferenceFile = '';
		bench.PHASE_REF = [];
	else
		bench.config.phaseReferenceFile = phaseReferenceFile;
		bench.PHASE_REF = naomi.data.PhaseReference(phaseReferenceFile);		
	end
end



