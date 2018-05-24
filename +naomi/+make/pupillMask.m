function [maskArray,maskData] = pupillMask(bench, mask, maskCenter)
	% Make a mask for the WFS
	% - bench : the bench object 
  % - mask : can be :
  %            -a string: name matching a mask defined in config 
  %                      bench.config.maskChoices gives a list of mask names
  %            -a 3 cell array defining {diameter, central-obscuration-diameter, unit}
  %                      unit must be 'm' or 'pixel'
  %            -a Matrix only the dimention of the matrix is checked, the mask is 
  %                       then return as is. Or an error is raised. If maskCenter 
  %                       is given it will be ignored
  % - maskCenter  (optional) is a 2 array giving the [xCenter yCenter] of the mask in pixel
  %               if mask center is given, the previously measured (or default) mirror center 
  %               will be taken 
    
    if nargin<2
        [mask, maskName] = bench.config.getMask(bench.config.ztcMask);
    else
        [mask, maskName] = bench.config.getMask(mask);
    end
    if iscell(mask)
      if length(mask)~=3
        error('Mask must be a string, a 3 cell array or a matrix');
      end
      pupillDiameter = mask{1};
      centralObscurtionDiameter = mask{2};
      unit = mask{3};
      switch unit
        case 'm'
          pupillDiameter = bench.meter2pixel(pupillDiameter);
        	centralObscurtionDiameter = bench.meter2pixel(centralObscurtionDiameter);
        case 'mm'
          pupillDiameter = bench.meter2pixel(pupillDiameter/1000.);
        	centralObscurtionDiameter = bench.meter2pixel(centralObscurtionDiameter/1000.);
        case 'cm'
          pupillDiameter = bench.meter2pixel(pupillDiameter/100.);
        	centralObscurtionDiameter = bench.meter2pixel(centralObscurtionDiameter/100.);
        case 'mum'
          pupillDiameter = bench.meter2pixel(pupillDiameter/1e6);
        	centralObscurtionDiameter = bench.meter2pixel(centralObscurtionDiameter/1e6);
        case 'pixel'
          % nothing to do 
        otherwise
          error('mask unit must be on of m, mm, cm, mum or pixel')
      end   
      
      if nargin<3 || isempty(maskCenter)
    		xCenter = bench.xCenter;
    		yCenter = bench.yCenter;
            
    		if isempty(xCenter) || isempty(yCenter)
    			error('WFs center has not been measured');
    		end
      else
        if length(maskCenter)~=2
          error('maskCenter must be a 2 array');
        end
        xCenter = maskCenter(1);
        yCenter = maskCenter(2);
    	end	
      
      maskArray = naomi.compute.pupillMask(bench.nSubAperture, pupillDiameter,centralObscurtionDiameter, xCenter, yCenter);
      if nargout>1
        K = naomi.KEYS;
        
        h = {{K.MPUPDIAM, bench.pixel2meter(pupillDiameter), K.MPUPDIAMc}, ...
             {K.MPUPDIAMPIX, pupillDiameter, K.MPUPDIAMPIXc}, ...
         	   {K.MXCENTER, xCenter, K.MXCENTERc},...
         	   {K.MYCENTER, xCenter, K.MYCENTERc},...
         	   {K.MCOBSDIAMPIX, centralObscurtionDiameter, K.MCOBSDIAMPIXc},...
             {K.MCOBSDIAM, bench.pixel2meter(centralObscurtionDiameter), K.MCOBSDIAMc},...  
             {K.MNAME,  maskName, K.MNAMEc}};
         maskData = naomi.data.Mask(maskArray, h);
         % just put haso information in the mask header
         bench.wfs.populateHeader(maskData.header);
         
    end  
      
      
    else
      if ~ismatrix(mask)
        error('Mask must be a string, a 3 cell array or a matrix');
      end
      [ny,nx] = size(mask);
      nSubAperture = bench.nSubAperture;
      
      if nx~=nSubAperture || ny~=nSubAperture
        error('mask does not match the dimension of the wfs');
      end
      maskArray = mask;
      
      if nargout>1
        K = naomi.KEYS;
        
        h = {{K.MNAME, naomi.KEYS.CUSTOM, K.MNAMEc}};
        maskData = naomi.data.Mask(maskArray, h);
        bench.wfs.populateHeader(maskData.header);
    end	 
  end
  
end
