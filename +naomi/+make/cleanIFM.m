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
		bench.log('WARNING: (IFMCleanData) the given IFMData has allready been cleaned');
	end		
	IFCleanMatrix = naomi.compute.cleanIFM(IFMData.data, Nexclude, Percentil);
	K = naomi.KEYS;
	h = {{K.MJDOBS,  IFMData.getKey(K.MJDOBS,0.0), K.MJDOBSc},...
	     {K.IFAMP ,  IFMData.getKey(K.IFAMP, -9.99), K.IFAMPc},...
	     {K.IFNPP  , IFMData.getKey(K.IFNPP,-9), K.IFNPPc},...
	     {K.IFMLOOP ,IFMData.getKey(K.IFMLOOP, -9),K.IFMLOOPc},...
	     {K.IFMPAUSE,IFMData.getKey(K.IFMPAUSE, -9.99),K.IFMPAUSEc},... 
	     {K.IFNEXC,  Nexclude,K.IFNEXCc},...
	     {K.IFPERC,  Percentil,K.IFPERC}};
  % TODO add more stolen keyword from the IFMData in make.cleanIFM 
	IFMCleanData = naomi.data.IFM(IFCleanMatrix, h);
	IFMCleanData.environmentData = IFMData.environmentData;
	naomi.copyHeaderKeys(IFMData, IFMCleanData, naomi.benchKeyList);
end