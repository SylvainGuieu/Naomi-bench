function F = gaussER(p,data)
    % 2d gaussian with rotation 
    % p is the gaussian parameters (6)  [amplitude, x0, xFwhm,  y0, yFwhm, rotAngle]
    % data must have the fields data.x and data.y 
    datarot(:,1)= data.x*cos(p(6)) - data.y*sin(p(6));
    datarot(:,2)= data.x*sin(p(6)) + data.y*cos(p(6));
    x0rot = p(2)*cos(p(6)) - p(4)*sin(p(6));
    y0rot = p(2)*sin(p(6)) + p(4)*cos(p(6));
 
    F = p(1)*exp(   -((datarot(:,1)-x0rot).^2/(2*p(3)^2) + (datarot(:,2)-y0rot).^2/(2*p(5)^2) )    );
end
 