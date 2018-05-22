function IFMCleanData = cleanIFM(bench, IFMData)
	config = bench.config;
	Percentil = config.ifmCleanPercentil;
	% :TODO: check if it is the full pupill or the naomi pupill
	Nexclude = int32(bench.meter2pixel(config.fullPupillDiameter) / 4.);

	if nargin<2
		if isempty(bench.IFMData)
			error('IFM has not been measureded');
		else
			IFMData = bench.IFMData;
		end
	end
	if IFMData.getKey('IF_NEXC', -99)>-99
		bench.config.log('Warning (IFMCleanData) the given IFMData has allready been cleaned');
	end		
	IFCleanMatrix = naomi.compute.cleanIFM(IFMData.data, Nexclude, Percentil);
	h = {{'MJD-OBS', IFMData.getKey('MJD-OBS',0.0), 'modified julian when IFM measured'},...
	     {'IF_AMP' , IFMData.getKey('AMP', -9.99),  '[Cmax] amplitude of push-pull'},...
	     {'IF_NPP'  ,IFMData.getKey('IF_NPP',-9), 'number of push-pull'},...
	     {'IF_LOOP' ,IFMData.getKey('IF_LOOP', -9),'number of push-pull'},...
	     {'IF_PAUSE',IFMData.getKey('IF_PAUSE', -9.99),'pause between actioner'},... 
	     {'IF_NEXC',Nexclude,'number of exclude pixel'},...
	     {'IF_PERC',Percentil,'percentil to compute piston'}};
	IFMCleanData = naomi.data.IFMatrix(IFCleanMatrix, h, {bench});	
end