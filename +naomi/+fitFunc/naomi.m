function F = naomi(p,data)
    % 2d circular gaussian 
    % p is the gaussian parameters (5)  [amplitude, x0, y0, fwhm]
    % data must have the fields data.x and data.y 
    F = p(1)*exp(   -(( (data.x-p(2)).^2 + (data.y-p(3)).^2)/(2*p(4)^2)).^0.75);
end