function [PtCArray, ZtCArray, ZtPArray, PtCData, ZtCData, ZtPData] = commandMatrix(bench, IFMData, ztcMode)
	% Compute the ZtC Matrix 
	% The only required parameter is bench all others are taken from 
	% measurement stored inside bench or inside config.  
	% the given IFMdata is preferably cleaned 

	if nargin<2 || isempty(IFMData)
		IFMData = bench.IFMData;
	end
  if nargin<3
    ztcMode = []; % default config parameters
    ztcModeName = bench.config.ztcMode;
  else
  	ztcModeName = ztcMode;
  end
    IFMArray = IFMData.data;
    
  IFC = squeeze(IFMArray(bench.config.dmCentralActuator,:,:));
	[xCenter,yCenter] = naomi.compute.IFCenter(IFC);
  
   
   % get the ztc parameters 
  [maskMeter, maskName,  nEigenValue, nZernike, zeroMean, ztcOrientation] = bench.ztcParameters(ztcMode, 'm');
  
  
  [xS,yS] = naomi.compute.IFMScale(IFMArray, bench.config.dmActuatorSeparation, bench.config.phaseOrientation);
  scale = 0.5 * (xS + yS);
  
  % convert the mask unit in pixel 
  mask = naomi.convertMaskUnit(maskMeter, 'pixel', scale);
  
  % TODO maybe parse the mask instead of pupillDiameterPix and centralObscurtionDiameterPix
  pupillDiameterPix = mask{1};
  centralObscurtionDiameterPix = mask{2};
  
	
	[PtCArray, ZtCArray, ZtPArray] = naomi.compute.commandMatrix(IFMArray, xCenter, yCenter, pupillDiameterPix, centralObscurtionDiameterPix,...
                                                                 nEigenValue, nZernike, zeroMean, ztcOrientation);
	if nargout>3
    K = naomi.KEYS;
    
    h = {{K.ZTCDIAM,    maskMeter{1}, K.ZTCDIAMc },... 
		 {K.ZTCOBSDIAM, maskMeter{2}, K.ZTCOBSDIAMc},... 
         {K.ZTCNEIG,    nEigenValue, K.ZTCNEIGc},...
         {K.ZTCNZERN,   nZernike, K.ZTCNZERN},...
         {K.ZTCZMEAN,   zeroMean, K.ZTCZMEANc},...
         {K.ZTCXCENTER, xCenter, K.ZTCXCENTERc},...
         {K.ZTCYCENTER, yCenter, K.ZTCYCENTERc},...
         {K.ZTCXSCALE,  xS, K.ZTCXSCALEc},...
         {K.ZTCYSCALE,  yS, K.ZTCYSCALEc},...
         {K.ZTCORIENT,  ztcOrientation, K.ZTCORIENT},...
         {K.ZTCMNAME,   maskName, K.ZTCMNAMEc},...
         {K.ZTCNAME,    ztcModeName , K.ZTCNAMEc},...
         {K.DPRVER,     ztcModeName,  K.DPRVERc} 
        };
      ZtCData = naomi.data.ZtC(ZtCArray, h);
      naomi.copyHeaderKeys(IFMData,ZtCData, naomi.ifmKeyList); % copy the relevant  IFM information
	  naomi.copyHeaderKeys(IFMData,ZtCData, {K.DATEOB});  % give the OBDATE the same as IFM
      naomi.copyHeaderKeys(IFMData, ZtCData, naomi.benchKeyList);	
      
      PtCData = naomi.data.PtC(PtCArray, ZtCData.header);
      ZtPData = naomi.data.ZtP(ZtPArray, ZtCData.header);
      
  end
end