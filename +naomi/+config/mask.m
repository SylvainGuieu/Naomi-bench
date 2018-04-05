function mask(bench, data_or_file)
	% configure the mask for the bench 
	% if not given a gui will ask for a file
	% Use only this function for fancy masking 
	% the function config.pupillMask is prefered to set up a classic pupill mask
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a Mask file');
		if isequal(file, 0); return; end;
		maskFile = fullfile(path, file);
		bench.maskData = naomi.data.Mask(maskFile);		
	else
		if ischar(data_or_file)	
			if strcmp(data_or_file, '')
				bench.maskData = [];
			else
				bench.maskData = naomi.data.Mask(data_or_file);				
			end		
		else
			bench.maskData = data_or_file;
		end
	end

	if bench.config.plotVerbose
		naomi.getFigure('Phase Mask');
		bench.maskData.plot();
	end
end
