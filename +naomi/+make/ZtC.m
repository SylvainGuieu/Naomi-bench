function ZtC = ZtC(bench, IFMData)
	% Compute the ZtC Matrix 
	% The only required parameter is bench all others are taken from 
	% measurement stored inside bench or inside config.  

	config = bench.config
	if nargin<2
		if isempty(bench.IFMCleanData)
			if isempty(bench.IFMData)
				error('No IFM has been loaded or measured')
			end
			IFMData = naomi.make.IFMClean(bench.IFMData);
		else
			IFMData = bench.IFMCleanData;
	end
	
	
	diameter = config.ztcPupillDiameter;	
	centralObscurtionDiameter = config.centralObscurtionDiameter; 
	Neig = config.ztcNeig;
	Nzern = config.Nzern;

	
	
	ZtCArray = naomi.compute.ZtC(IFMData.data,  diameter,  centralObscurtionDiameter, config.dmCentralActuator, Neig, Nzer);

	h = {{'MJD-OBS', IFMData.getKey('MJD-OBS',0.0), 'modified julian when IFM measured'},
	     {'IF_AMP' , IFMData.getKey('AMP',   -9.99),  '[Cmax] amplitude of push-pull'},
	     {'IF_NPP'  ,IFMData.getKey('IF_NPP',  -9), 'number of push-pull'},
	     {'IF_LOOP' ,IFMData.getKey('IF_LOOP', -9),'number of push-pull'},
	     {'IF_PAUSE',IFMData.getKey('IF_PAUSE', -9.99),'pause between actioneu'}, 
	     {'IF_NEXC', IFMData.getKey('IF_NEXC', -9),'number of exclude pixel'},
	     {'IF_PERC', IFMData.getKey('IF_PERC' , -9.99),'percentil to compute piston'}, 
         {'DIAM', diameter, 'Pupill Diameter'}, 
         {'NEIG', Neig, 'Number of Eigen'},
         {'NZER', Nzer, 'Number of Zerniques'}
	    };
	
	if strcomp(config.ztcMode, 'naomi')
		h{length(h)} = {'DPR_TYPE', 'NTC_MATRIX', ''};
	end
	ZtC = naomi.data.ZtC(ZtCArray, h, {bench});			
end