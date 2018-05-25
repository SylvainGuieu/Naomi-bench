function fitResult = fittedIFprofile(img, fitType, sigmaGuess, amplitudeGuess)
    if nargin<2
        fitType = 'naomi';
    end
    
    if nargin<3
        sigmaGuess = 100; %typical for naomi
    end
    if nargin<4
        amplitudeGuess = 7; %typical for naomi
    end
    
    
    % guess the center by barycenter for initial value 
    % this is necessary for the fit to comverge properly 
    [xC, yC] = naomi.compute.IFCenter(img);
    [xSize, ySize] = size(img);
    
    if strcmp(fitType, 'maximum')
        s = sign(img(min(max(int32(yC),1),ySize),min(max(int32(xC),1), xSize)));
        b = 4;
        % take the maximum of a small box within the xC, yC
        boxed = img( max(int32(yC-b),1):min(int32(yC+b),ySize), ...
                     max(int32(xC-b),1):min(int32(xC+b),ySize));
%         boxed = img( max(int32(xC-b),1):min(int32(xC+b),ySize), ...
%                      max(int32(yC-b),1):min(int32(yC+b),ySize));
        
        if s>0
            amplitude = max(boxed(:));
        else
            amplitude = min(boxed(:));
        end
        % compute the sum of what is superior to maximum half
        num = naomi.compute.nansum(reshape(img,xSize*ySize,1) > amplitude * 0.5);
        % and deduct the full width of maximum
        hwhm= sqrt(num/3.14159);
        
        fitResult = [];
        fitResult.type = 'maximum';
        fitResult.args = [amplitude, xC, yC, hwhm];
        fitResult.amplitude = amplitude;
        fitResult.xCenter = xC;
        fitResult.yCenter = yC;
        fitResult.xHwhm = hwhm;
        fitResult.yHwhm = hwhm;
        fitResult.hwhm = hwhm;
        fitResult.angle = 0.0;
        fitResult.offset = 0.0;
        return 
    end
   
    [X,Y] = meshgrid(1:xSize, 1:ySize);
 	
    mask = ~isnan(img);
    
    Z = img(mask);
    X = X(mask);
    Y = Y(mask);
    
   
    
    
    fluxTreshold = 0.1;
    aZ = abs(Z);
    t =  max(aZ)* fluxTreshold;
    fluxMask =  (aZ > t);
    
    
    
    % limits the image to points around xC, yC 
    maxRadius = 15;
    maskIn = (X-xC).^2 +  (Y-yC).^2 <= maxRadius^2;
    
    %m3 = (X>(xC-bSizeO/2)) & (X<(xC+bSizeO/2)) & (Y>(yC-bSizeO/2)) & (Y<(yC+bSizeO/2));
   
    % take only the points with enough flux or within a box around the max
    % point
    mask =  fluxMask | maskIn;
    
    % compute the offset background from everything
    % that is not inside the radius 
    offset = median(Z(~mask));
    Z = Z(mask);
    X = X(mask);
    Y = Y(mask);


%     Z = Z(m2);
%     X = X(m2);
%     Y = Y(m2);
    
    data = [];
    data.x = X;
    data.y = Y;
    % substract the offset to data
    % the offset value is stored in fitResult
    % the offset is then added to model with the function naomi.compute.ifmProfileModel
    Z = Z-offset;
    
    
    switch fitType
         case 'gauss'
            args0 = [amplitudeGuess,xC, sigmaGuess, yC];
            lb = [-realmax('double'), 1, 0.0, 1 ];
            ub = [realmax('double'), xSize,xSize,ySize];
            func = @naomi.fitFunc.gauss;
        case 'naomi'
            args0 = [amplitudeGuess,xC, sigmaGuess, yC];
            lb = [-realmax('double'), 1, 0.0, 1 ];
            ub = [realmax('double'), xSize,xSize,ySize];
            func = @naomi.fitFunc.naomi;
        case 'gaussER'
            args0 = [amplitudeGuess,xC, sigmaGuess, yC, sigmaGuess, 0.0];
            % define lower and upper bounds [Amp,xo,wx,yo,wy, phi]
            lb = [-realmax('double'), 1, 0.0, 1, 0.0, -pi/4];
            ub = [realmax('double') ,xSize,xSize,ySize,ySize,pi/4];
            func = @naomi.fitFunc.gaussER;
            
        case 'gaussE'
            args0 = [amplitudeGuess,xC, sigmaGuess, yC, sigmaGuess];
            lb = [-realmax('double'), 1, 0.0, 1, 0.0];
            ub = [realmax('double'), xSize,xSize,ySize,ySize];
            func = @naomi.fitFunc.gaussE;
        case 'lorentzE'
            args0 = [amplitudeGuess,xC, sigmaGuess, yC, sigmaGuess];
            lb = [-realmax('double'), 1, 0.0, 1, 0.0];
            ub = [ realmax('double'), xSize,xSize,ySize,ySize];
            func = @naomi.fitFunc.lorentzE;
        case 'lorentz'
            args0 = [amplitudeGuess,xC, yC, sigmaGuess];
            lb = [-100, 0.0  , 0.0 , 0.0];
            ub = [ 100, xSize,xSize, 40];
            func = @naomi.fitFunc.lorentz;
        otherwise
            error('Fit Type must be gaussR, gauss or lorentz');
    end
    opts = optimset('Display','off');
    [args,resnorm,residual,exitFlag] = lsqcurvefit(func,args0,data,Z,lb,ub, opts);
    
    fitResult = [];
    fitResult.args = args;
    fitResult.type = fitType;
    fitResult.residual = residual;
    fitResult.exitFlag = exitFlag;
    
    fitResult.amplitude = args(1);
    fitResult.offset = offset;
    switch fitType
        case {'gauss', 'naomi'}
            fitResult.xCenter = args(2);
            fitResult.yCenter = args(3);
            fitResult.xHwhm = args(4);
            fitResult.yHwhm = args(4);
            fitResult.hwhm = args(4);
            fitResult.angle = 0.0;
        case 'gaussE'
            fitResult.xCenter = args(2);
            fitResult.yCenter = args(4);
            fitResult.xHwhm = args(3);
            fitResult.yHwhm = args(5);
            fitResult.hwhm = (args(3)+args(5))/2.0;
            fitResult.angle = 0.0;
        case 'gaussER'
            fitResult.xCenter = args(2);
            fitResult.yCenter = args(4);
            fitResult.xHwhm = args(3);
            fitResult.yHwhm = args(5);
            fitResult.hwhm = (args(3)+args(5))/2.0;
            fitResult.angle = args(6);
        case 'lorentzE'
            fitResult.xCenter = args(2);
            fitResult.yCenter = args(4);
            fitResult.xHwhm = args(3);
            fitResult.yHwhm = args(5);
            fitResult.hwhm = (args(3)+args(5))/2.0;
            fitResult.angle = 0.0;
        case 'lorentz'
            fitResult.xCenter = args(2);
            fitResult.yCenter = args(3);
            fitResult.xHwhm = args(4);
            fitResult.yHwhm = args(4);
            fitResult.hwhm = args(4);
            fitResult.angle = 0.0;
    end
    
end


