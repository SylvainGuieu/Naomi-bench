function args = gauss2dFit(img, fitOrientation, sigmaGuess, amplitudeGuess)
    if nargin<3
        sigmaGuess = 100; %typical for naomi
    end
    if nargin<4
        amplitudeGuess = 7; %typical for naomi
    end
    if nargin<2
        fitOrientation = 0;
    end
 
    % guess the center by barycenter for initial value
    [xC, yC] = naomi.compute.IFCenter(img);
    % limits the image to a box around xC, yC
    bSize= 15;
    xCi = int32(xC);
    yCi = int32(yC);
    
    %img = img(max(1:xCi-bSize));
    [xSize, ySize] = size(img);
    [Y,X] = meshgrid(1:xSize, 1:ySize);
 	
    mask = ~isnan(img);
    
    Z = img(mask);
    X = X(mask);
    Y = Y(mask);
    m2 = (X>(xC-bSize/2)) & (X<(xC+bSize/2)) & (Y>(yC-bSize/2)) & (Y<(yC+bSize/2));
    Z = Z(m2);
    X = X(m2);
    Y = Y(m2);
    [realDataSize,~] =  size(Z);
    
    argsData = zeros(realDataSize, 2);
    argsData(:,1) = X;
    argsData(:,2) = Y;
    
    
    
    if fitOrientation
        
        args0 = [amplitudeGuess,xC, sigmaGuess, yC, sigmaGuess, 0.0];
        
        % define lower and upper bounds [Amp,xo,wx,yo,wy, phi]
        lb = [-realmax('double'), 1, xSize, 1, ySize, -pi/4];
        ub = [realmax('double') ,xSize,xSize,ySize,ySize,pi/4];
        [args,resnorm,residual,exitflag] = lsqcurvefit(@gaussFunctionRot,args0,argsData,Z,lb,ub);
    else
        args0 = [amplitudeGuess,xC, sigmaGuess, yC, sigmaGuess];
        lb = [-realmax('double'), 1, 0.0, 1, 0.0];
        ub = [realmax('double'), xSize,xSize,ySize,ySize];
        %ub = [10,xSize,xSize,ySize,ySize];
        [args,resnorm,residual,exitflag] = lsqcurvefit(@lorentzian,args0,argsData,Z,lb,ub);      
        %[args,resnorm,residual,exitflag] = lsqcurvefit(@gaussFunction,args0,argsData,Z,lb,ub);      
    end
 
end
 
 
function F = gaussFunction(x,xdata)
 %% x = [Amp, x0, wx, y0, wy]
 F = x(1)*exp(   -((xdata(:,1)-x(2)).^2/(2*x(3)^2) + (xdata(:,2)-x(4)).^2/(2*x(5)^2) )    );
end
 
function F = gaussFunctionRot(x,xdata)
    %% x = [Amp, x0, wx, y0, wy, fi]
    
    xdatarot(:,1)= xdata(:,1)*cos(x(6)) - xdata(:,2)*sin(x(6));
    xdatarot(:,2)= xdata(:,1)*sin(x(6)) + xdata(:,2)*cos(x(6));
    x0rot = x(2)*cos(x(6)) - x(4)*sin(x(6));
    y0rot = x(2)*sin(x(6)) + x(4)*cos(x(6));
 
    F = x(1)*exp(   -((xdatarot(:,1)-x0rot).^2/(2*x(3)^2) + (xdatarot(:,2)-y0rot).^2/(2*x(5)^2) )    );
end


    
function F = lorentzian(x, xdata)
    F = x(1) ./ ((xdata(:,1) - x(2)).^2 / (x(3) / 2.)^2 + (xdata(:,2) - x(4)).^2 / (x(5) / 2.)^2 + 1);
end
function F = lorentzian_(x, xdata)
        % we can assume that the number of parameters in x and the
        % structure in xdata is correct because this was checked above

        % the number of different lorentzians in the sum is n
        dim = 2;
        n = (length(x) - 1) / (2 * dim + 1);

        % set background
        F = zeros(size(xdata(:,1))) + x(1);

        % for all peaks
        for ki = 1 : n
            % get the right parameters for this peak out of x
            si = 2 + (ki - 1) * (2 * dim + 1);
            p = x(si:si+2*dim);
            % depending on dimensionality add a peak
            switch dim
                case 1
                     F= F + p(1) ./ ((xdata(:,1) - p(2)).^2 / (p(3) / 2.)^2 + 1);
                case 2
                    F = F + p(1) ./ ((xdata(:,1) - p(2)).^2 / (p(3) / 2.)^2 + (xdata(:,2) - p(4)).^2 / (p(5) / 2.)^2 + 1);
            end % no error handling necessary m.dim was set by us
        end
    end