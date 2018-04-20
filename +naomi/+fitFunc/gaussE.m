function F = gaussE(p,data)
    % 2d elliptical gaussian 
    % p is the gaussian parameters (5)  [amplitude, x0, xFwhm,  y0, yFwhm]
    % data must have the fields data.x and data.y 
    F = p(1)*exp(   -((data.x-p(2)).^2/(2*p(3)^2) + (data.y-p(4)).^2/(2*p(5)^2)));
end