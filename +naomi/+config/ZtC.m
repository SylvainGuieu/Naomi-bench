function ZtC(bench, data_or_file)
	% configure the Zernique to Command Matrix 
	% if not given a gui ask for a fits file 
	% execption, if the argument is 
	% -'compute' the ZtC is computed from a previously measured 
	%		     or load IFM if the bench does not contain IFM 
	%            an error is returned 
	% -'measure' the IFM is measured and than ZtC is computed
	% -'compute or measure' the ZtC is computed if IFM has been 
	%	                    measured otherwise the IFM is measured
	if nargin<2
		[file, path] = naomi.askFitsFile('Select a Mask file');
		if isequal(file, 0); return; end;
		maskFile = fullfile(path, file);
		bench.ZtCData = naomi.data.ZtC(maskFile);		
	else
		if ischar(data_or_file)	
			if strcmp(data_or_file, '')
				bench.ZtCData = [];
			else
				switch data_or_file
				case 'compute'
				
					bench.ZtCData = naomi.make.ZtC(bench); % compute the ZtC from the measured IFM 
				case 'measure'
					naomi.measure.IFM(bench);
					bench.ZtCData = naomi.make.ZtC(bench); 
				case 'compute or measure'
					if isempty(bench.IFMData)
						naomi.measure.IFM(bench);
					end
					bench.ZtCData = naomi.make.ZtC(bench); 					
				otherwise
					bench.ZtCData = naomi.data.ZtC(data_or_file);				
				end	
			end	
		else
			bench.ZtCData = data_or_file;
		end
    end
    if bench.config.plotVerbose
        naomi.getFigure('Zernique to Command');
        bench.ZtCData.plot();
    end
end