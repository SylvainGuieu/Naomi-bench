function ZtCData = ZtC(bench, IFMData)
	% Compute the ZtC Matrix 
	% The only required parameter is bench all others are taken from 
	% measurement stored inside bench or inside config.  
	% the given IFMdata is preferably cleaned 

	config = bench.config
	if nargin<2
		IFMData = bench.IFMData;
	end
	
	
	[pupillDiameter, centralObscurtionDiameter] = bench.getMaskInMeter(config.ztcMask);
	
	nEigenValue = config.ztcNeigenValue;
	nZernike = config.ztcNzernike;
  
	
	
	ZtCArray = naomi.compute.ZtC(IFMData.data,  pupillDiameter, centralObscurtionDiameter, config.dmCentralActuator, nEigenValue, nZernike);
	
	K = naomi.KEYS;
	
	h = {{K.MJDOBS,  IFMData.getKey(K.MJDOBS,0.0), K.MJDOBSc},...
	     {K.IFAMP ,  IFMData.getKey('AMP',   -9.99),  K.IFAMPc},...
	     {IFNPP  ,   IFMData.getKey(K.IFNPP,  -9), K.IFNPPc},...
	     {K.IFMLOOP ,IFMData.getKey(K.IFMLOOP, -9),K.IFMLOOP},...
	     {K.IFMPAUSE,IFMData.getKey(K.IFMPAUSE, -9.99), K.IFMPAUSEc},... 
	     {K.IFNEXC,  IFMData.getKey(K.IFNEXC, -9),K.IFNEXCc},...
	     {K.IFPERC,  IFMData.getKey(K.IFPERC , -9.99), K.IFPERCc},... 
       {K.MPUPDIAM,   pupillDiameter, K.MPUPDIAMc},... 
			 {K.ZTCDIAM,    pupillDiameter, K.ZTCDIAMc},... 
       {K.MPUPDIAMPIX, bench.meter2pixel(pupillDiameter),K.MPUPDIAMPIXc},...
       {K.ZTCNEIG, nEigenValue, K.ZTCNEIGc},...
       {K.NZERN, nZernike, K.NZERN},... 
			 {K.ZTCNZERN, nZernike, K.ZTCNZERN} 
	    };
	
	if strcmp(config.ztcMode, 'naomi')
		h{length(h)} = {K.DPRTYPE, 'ZTC_MATRIX', K.DPRTYPEc};
	end
	ZtCData = naomi.data.ZtC(ZtCArray, h, {bench});			
end