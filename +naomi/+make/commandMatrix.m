function [PtCArray, ZtCArray, ZtPArray, PtCData, ZtCData, ZtPData] = commandMatrix(bench, IFMData, ztcMode)
	% Compute the ZtC Matrix 
	% The only required parameter is bench all others are taken from 
	% measurement stored inside bench or inside config.  
	% the given IFMdata is preferably cleaned 

	config = bench.config
	if nargin<2 || isempty(IFMData)
		IFMData = bench.IFMData;
	end
  if nargin<3
    ztcMode = []; % default config parameters
		ztcModeName = bench.config.ztcMode;
  else
  	ztcModeName = ztcMode;
	end
  IFC = squeeze(IFM(bench.config.dmCentralActuator,:,:));
	[xCenter,yCenter] = naomi.compute.IFCenter(IFC);
  
  [mask, nEigenValue, nZernike, zeroMean] = bench.config.ZtCParameters(ztcMode);
	[pupillDiameter, centralObscurtionDiameter] = bench.getMaskInMeter(mask);
  
  [xS,yS] = naomi.compute.IFMScale(IFM, bench.config.dmActuatorSeparation, orientation);
  scale = 0.5 * (xS + yS);
  pupillDiameterPix = pupillDiameter / scale;
  centralObscurtionDiameterPix = centralObscurtionDiameter / scale;
  
	
	[PtCArray, ZtCArray, ZtPArray] = naomi.compute.commandMatrix(IFMData.data, xCenter, yCenter, pupillDiameterPix, centralObscurtionDiameterPix,...
                                                               nEigenValue, nZernike, zeroMean);
	if nargout>3
    K = naomi.KEYS;
    
    h = {{K.ZTCDIAM,    pupillDiameter, K.ZTCDIAMc },... 
		     {K.ZTCOBSDIAM, centralObscurtionDiameterPix, K.ZTCOBSDIAMc},... 
         {K.ZTCNEIG,    nEigenValue, K.ZTCNEIGc},...
         {K.ZTCNZERN,   nZernike, K.ZTCNZERN},...
				 {K.ZTCZMEAN,   zeroMean, K.ZTCZMEANc},...
				 {K.ZTCXCENT,   xCenter, K.ZTCXCENTc},...
				 {K.ZTCYCENT,   yCenter, K.ZTCYCENTc},...
				 {K.ZTCXSCALE,  xS, K.ZTCXSCALEc},...
				 {K.ZTCXSCALE,  yS, K.ZTCXSCALEc},...
				 {K.ZTCNAME,    ztcModeName , K.ZTCNAMEc},...
         {K.DPRVER,     ztcModeName,  K.DPRVERc} 
        };
      ZtCData = naomi.data.ZtC(ZtCArray, h);
			naomi.copyHeaderKeys(IFMData,ZtCData, {K.DATEOB, K.IFAMP, K.IFNPP, K.IFMLOOP, K.IFMPAUSE, K.IFNEXC, K.IFPERC});
      naomi.copyHeaderKeys(IFMData, ZtCData, naomi.benchKeyList);	
      
      PtCData = naomi.data.PtC(PtCArray, ZtCData.header);
      ZtPData = naomi.data.ZtP(ZtPArray, ZtCData.header);
      
  end
end