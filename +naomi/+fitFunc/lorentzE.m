function F = lorentzE(p, data)
    % 2d lorentzian
    % p is the lorentz parameters (5)  [amplitude, x0, xHwhm,  y0, yHwhm]
    % data must have the fields data.x and data.y 
    F = p(1) ./ ((data.x - p(2)).^2 / (p(3) )^2 + (data.y - p(4)).^2 / (p(5) )^2 + 1);
end
