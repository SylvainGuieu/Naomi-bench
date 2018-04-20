function F = gauss2d(args, xArray, yArray)
    switch length(args)
        case 5
           F =  gaussFunction(args,xArray,yArray);
           F =  lorentzian(args,xArray,yArray);
        case 6
            F =  gaussFunctionRot(args,xArray,yArray);
        otherwise
            error(sprintf('number of gauss argument must be 5 or 6 got %d', length(args)));
    end
end
function F = gaussFunction(args,X,Y)
 %% x = [Amp, x0, wx, y0, wy]
 F = args(1)*exp(   -((X-args(2)).^2/(2*args(3)^2) + (Y-args(4)).^2/(2*args(5)^2) )    );
end
 
function F = gaussFunctionRot(args, X, Y)
    %% x = [Amp, x0, wx, y0, wy, fi]
    
    Xrot= X*cos(args(6)) - Y*sin(args(6));
    Yrot= X*sin(args(6)) + Y*cos(args(6));
    x0rot = args(2)*cos(args(6)) - args(4)*sin(args(6));
    y0rot = args(2)*sin(args(6)) + args(4)*cos(args(6));
 
    F = x(1)*exp(   -((Xrot-x0rot).^2/(2*args(3)^2) + (Yrot-y0rot).^2/(2*args(5)^2) ));
end

function F = lorentzian(args, X, Y)
    F = args(1) ./ ((X - args(2)).^2 / (args(3) / 2.)^2 + (Y - args(4)).^2 / (args(5) / 2.)^2 + 1);
end
