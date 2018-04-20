function F = lorentz(p, data)
    % 2d simetrical lorentzian
    % p is the lorentz parameters (5)  [amplitude, x0, y0, xHwhm]
    % data must have the fields data.x and data.y 
    F = p(1) ./ ((data.x - p(2)).^2 / (p(4))^2 + (data.y - p(3)).^2 / (p(4))^2 + 1);
end
