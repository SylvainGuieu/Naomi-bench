function ZtCData = ZtC(bench, IFMData)
	% Compute the ZtC Matrix 
	% The only required parameter is bench all others are taken from 
	% measurement stored inside bench or inside config.  

	config = bench.config
	if nargin<2
		IFMData = bench.IFMData;
	end
	
	
	diameter = config.ztcPupillDiameter;	
	centralObscurtionDiameter = config.ztcCentralObscurtionDiameter; 
	nEigenValue = config.ztcNeigenValue;
	nZernike = config.ztcNzernike;
    
	
	
	ZtCArray = naomi.compute.ZtC(IFMData.data,  diameter,  centralObscurtionDiameter, config.dmCentralActuator, nEigenValue, nZernike);

	h = {{'MJD-OBS', IFMData.getKey('MJD-OBS',0.0), 'modified julian when IFM measured'},
	     {'IF_AMP' , IFMData.getKey('AMP',   -9.99),  '[Cmax] amplitude of push-pull'},
	     {'IF_NPP'  ,IFMData.getKey('IF_NPP',  -9), 'number of push-pull'},
	     {'IF_LOOP' ,IFMData.getKey('IF_LOOP', -9),'number of push-pull'},
	     {'IF_PAUSE',IFMData.getKey('IF_PAUSE', -9.99),'pause between actioneu'}, 
	     {'IF_NEXC', IFMData.getKey('IF_NEXC', -9),'number of exclude pixel'},
	     {'IF_PERC', IFMData.getKey('IF_PERC' , -9.99),'percentil to compute piston'}, 
         {'DIAM', diameter, 'Pupill Diameter in [m]'}, 
         {'DIAMPIX', bench.meter2pixel(diameter),'Pupill Diameter in wfs pixel'},
         {'NEIG', nEigenValue, 'Number of Eigen'},
         {'NZER', nZernike, 'Number of Zerniques'}
	    };
	
	if strcmp(config.ztcMode, 'naomi')
		h{length(h)} = {'DPR_TYPE', 'ZTC_MATRIX', ''};
	end
	ZtCData = naomi.data.ZtC(ZtCArray, h, {bench});			
end