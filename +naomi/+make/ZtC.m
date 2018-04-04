function ZtC = ZtC(bench, diameter_or_mode)
	% Compute the ZtC Matrix 
	% The only required parameter is bench all others are taken from 
	% measurement stored inside bench or inside config.  

	config = bench.config

	
	if nargin<2; 
		diameter = config.ztcPupillDiameter;	
		Neig = config.ztcNeig;
		Nzern = config.Nzern;
	elseif ischar(diameter_or_mode)
		config.ztcMode = diameter_or_mode;
		diameter = config.ztcPupillDiameter;	
		Neig = config.ztcNeig;
		Nzern = config.Nzern;
	elseif iscell(diameter_or_mode)
		diameter = diameter_or_mode{1};
		Neig = diameter_or_mode{2};
		Nzern = diameter_or_mode{3};
	else 
		error('second argument should be char for mode or a 3xcell array for {diameter,Neig,Nzern}');
	end

	
	
	if isempty(bench.IFM)
		error('IFM should be measured first');
	end
	if empty(bench.IFMClean)
		naomi.make.cleanIFM(bench);
	end
	IFM = bench.IFMClean; 	
	ZtCArray = naomi.compute.ZtC(IFM.data,  diameter, config.dmCentralActuator, Neig, Nzer);

	h = {{'MJD-OBS', IFM.getKey('MJD-OBS',0.0), 'modified julian when IFM measured'},
	     {'IF_AMP' , IFM.getKey('AMP',   -9.99),  '[Cmax] amplitude of push-pull'},
	     {'IF_NPP'  ,IFM.getKey('IF_NPP',  -9), 'number of push-pull'},
	     {'IF_LOOP' ,IFM.getKey('IF_LOOP', -9),'number of push-pull'},
	     {'IF_PAUSE',IFM.getKey('IF_PAUSE', -9.99),'pause between actioneu'}, 
	     {'IF_NEXC', IFM.getKey('IF_NEXC', -9),'number of exclude pixel'},
	     {'IF_PERC', IFM.getKey('IF_PERC' , -9.99),'percentil to compute piston'}, 
         {'DIAM', diameter, 'Pupill Diameter'}, 
         {'NEIG', Neig, 'Number of Eigen'},
         {'NZER', Nzer, 'Number of Zerniques'}
	    };
	
	if strcomp(config.ztcMode, 'naomi')
		h{length(h)} = {'DPR_TYPE', 'NTC_MATRIX', ''};
	end
	ZtC = naomi.data.ZtC(ZtCArray, h, {bench});	
	bench.ZtC = ZtC; % this will update the bench.dm.zernike2Command
end