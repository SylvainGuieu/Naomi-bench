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
    
    
    [mask, maskName] = bench.config.getMask(mask);
    
    if iscell(mask)
      if length(mask)~=3
        error('Mask must be a string, a 3 cell array or a matrix');
      end
      pupillDiameter = mask{1};
      centralObscurtionDiameter = mask{2};
      unit = mask{3};
      switch unit
        case 'm'
          pupillDiameter = bench.sizePix(pupillDiameter);
        	centralObscurtionDiameter = bench.sizePix(centralObscurtionDiameter);
        case 'mm'
          pupillDiameter = bench.sizePix(pupillDiameter/1000.);
        	centralObscurtionDiameter = bench.sizePix(centralObscurtionDiameter/1000.);
        case 'cm'
          pupillDiameter = bench.sizePix(pupillDiameter/100.);
        	centralObscurtionDiameter = bench.sizePix(centralObscurtionDiameter/100.);
        case 'mum'
          pupillDiameter = bench.sizePix(pupillDiameter/1e6);
        	centralObscurtionDiameter = bench.sizePix(centralObscurtionDiameter/1e6);
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
      
      maskArray = naomi.compute.pupillMask(bench.nSubAperture, puppillDiameter,centralObscurtionDiameter, xCenter, yCenter);
      
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
    end
    
	
	 if nargout>1
     K = nami.KEYS;
      h = {{'PUPDIAM', pupillDiameter, 'Mask pupill diameter in [m]'}, 
      	   {'XCENTER', xCenter, 'Mask X Center [pixel]'},
      	   {'YCENTER', xCenter, 'Mask Y Center [pixel]'},
      	   {'OBSCU', centralObscurtionDiameter, 'Mask central obscurtion diameter [m]'}, 
           {'MNAME', maskName, 'Mask Name'}
      	};
      maskData = naomi.data.Mask(maskArray, h, {bench});
  end
  
end
