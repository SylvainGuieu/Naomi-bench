function mask = convertMaskUnit(maskIn, unit, pixelScale)
%CONVERTMASK Sconvert the unit of a mask definietion 
%   unit can be 'pixel', 'm' , 'cm' or 'mm'
%   pixelScale is always in m/pixel
v = [maskIn{1}, maskIn{2}];
u = maskIn{3};

er = 'invalid unit, expecting pixel, m, cm or mm got %s';
switch u 
    case 'pixel'
        switch unit
            case 'pixel'
            case 'm'
                v = v * pixelScale;
            case 'mm'
                 v = v * pixelScale * 1000;
            case 'cm'
                v = v * pixelScale * 100;
            otherwise
                    error(er, unit);
        end
    case 'm'
        switch unit
            case 'pixel'
                v = v / pixelScale;
            case 'm'
            case 'mm'
                v = v * 1000;
            case 'cm'
                v = v * 100;
            otherwise
                    error(er, unit);
        end
    case 'mm'
        switch unit
            case 'pixel'
                v = v / 1000. / pixelScale;
            case 'm'
                v = v/ 1000.
            case 'mm'
               
            case 'cm'
                v = v / 10;
            otherwise
                    error(er, unit);
        end
    
     case 'cm'
        switch unit
            case 'pixel'
                v = v / 100. / pixelScale;
            case 'm'
                v = v/ 100.
            case 'mm'
                v = v * 10;
            case 'cm'
               
            otherwise
                    error(er, unit);
        end
    otherwise
        error('unknown unit in mask definition expecting pixel, m, cm or mm got %s', u);
end
mask = {v(1), v(2), unit};
                
end

