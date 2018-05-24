function [PtCArray, ZtCArray, ZtPArray, PtCAData, ZtCData, ZtPData] = commandMatrix(bench, IFMData, ztcMode)
	% Compute the ZtC Matrix 
	% The only required parameter is bench all others are taken from 
	% measurement stored inside bench or inside config.  
	% the given IFMdata is preferably cleaned 

	config = bench.config
	if nargin<2
		IFMData = bench.IFMData;
	end
  if nargin<3
    ztcMode = bench.config.ztcMode;
  end
	
  IFC = squeeze(IFM(dmCenterAct,:,:));
	[xCenter,yCenter] = naomi.compute.IFCenter(IFC);
  [mask, nEigenValue, nZernike, zeroMean] = bench.config.ZtCParameters(ztcMode);
	[pupillDiameter, centralObscurtionDiameter] = bench.getMaskInMeter(mask);
  
  
	
	
	[PtCArray, ZtCArray, ZtPArray] = naomi.compute.commandMatrix(IFMData.data,xCenter, yCenter,  pupillDiameter, centralObscurtionDiameter, nEigenValue, nZernike, zeroMean);
	if nargout>3
    K = naomi.KEYS;
    
    h = {{K.MJDOBS,  IFMData.getKey(K.MJDOBS,   0.0 ), K.MJDOBSc},...
         {K.IFAMP ,  IFMData.getKey(K.IFAMP,   -9.99), K.IFAMPc},...
         {K.IFNPP  , IFMData.getKey(K.IFNPP,   -9   ), K.IFNPPc},...
         {K.IFMLOOP ,IFMData.getKey(K.IFMLOOP, -9   ), K.IFMLOOP},...
         {K.IFMPAUSE,IFMData.getKey(K.IFMPAUSE,-9.99), K.IFMPAUSEc},... 
         {K.IFNEXC,  IFMData.getKey(K.IFNEXC,  -9   ), K.IFNEXCc},...
         {K.IFPERC,  IFMData.getKey(K.IFPERC , -9.99), K.IFPERCc},... 
         {K.MPUPDIAM, pupillDiameter, K.MPUPDIAMc},... 
         {K.ZTCDIAM,  pupillDiameter, K.ZTCDIAMc },... 
         {K.MPUPDIAMPIX, bench.meter2pixel(pupillDiameter),K.MPUPDIAMPIXc},...
         {K.ZTCNEIG,  nEigenValue, K.ZTCNEIGc},...
         {K.NZERN,    nZernike, K.NZERN},... 
         {K.ZTCNZERN, nZernike, K.ZTCNZERN},...
         {K.DPRVER,   ztcMode,  K.DPRVERc} 
        };
      ZtCData = naomi.data.ZtC(ZtCArray, h);
      naomi.copyHeaderKeys(IFMData, ZtCData, naomi.benchKeyList);	
      
      PtCData = naomi.data.PtC(PtCArray, ZtCData.header);
      ZtPData = naomi.data.ZtP(ZtPArray, ZtCData.header);
      
  end
end