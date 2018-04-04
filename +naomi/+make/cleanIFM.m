function IFMClean = cleanIFM(bench)
	config = bench.config;
	Percentil = config.ifmCleanPercentil;
	Nexclude = int32(bench.sizePix(config.pupillDiameter) / 4.);

	if isempty(bench.IFM)
		error('IFM has not been measureded');
	end
	IFM = bench.IFM;
	
	IFMcleanArray = naomi.compute.cleanIFM(bench.IFM.data, Nexclude, Percentil);
	h = {{'MJD-OBS', IFM.getKey('MJD-OBS',0.0), 'modified julian when IFM measured'},
	     {'IF_AMP' , IFM.getKey('AMP', -9.99),  '[Cmax] amplitude of push-pull'},
	     {'IF_NPP'  ,IFM.getKey('IF_NPP',-9), 'number of push-pull'},
	     {'IF_LOOP' ,IFM.getKey('IF_LOOP', -9),'number of push-pull'},
	     {'IF_PAUSE',IFM.getKey('IF_PAUSE', -9.99),'pause between actioneu'}, 
	     {'IF_NEXC',Nexclude,'number of exclude pixel'},
	     {'IF_PERC',Percentil,'percentil to compute piston'}};
	IFMClean = naomi.data.IFM(IFMCleanArray, h, {bench});
	
end