
function [shortName, longName, equationStr] = zernikeInfo(zernike)
	
	[n,m] = zernike2Noll(zernike);


    shortNames = {'piston',...
    'tip','tilt',...
    'focus','oastig','vastig',...
    'vcoma','hcoma','vtrefoil','otrefoil',...
    'spherical','v2astig','o2astig','vquadrafoil','oquadrafoil',...
    'h2coma','v2coma','o2trefoil','v2trefoil','opentafoil','vpentafoil'};

    if zernike>length(shortNames)
        shortName = sprintf('Z%d', zernike);        
    else
        shortName = shortNames{zernike};
    end
    if nargout>1
        longNames = {'Piston', 'Tip', 'Tilt', ...
             'Focus', 'Astigmatism 45', 'Astigmatism 0', ...
             'Coma Y', 'Coma X', ...
             'Trefoil Y', 'Trefoil X', ...
             'Spherical', '2nd Astig 0', '2nd Astig 45', ...
             'Tetrafoil 0', 'Tetrafoil 22.5', ...
             '2nd coma X', '2nd coma Y', '3rd Astig X', '3rd Astig Y', ...
             'Pentafoil X', 'Pentafoil Y', '5th order spherical'};
        if zernike>length(longNames)
            longName = sprintf('Zernike %d', zernike);
        else
            longName = longNames{zernike};
        end
    end

    if nargout>2
    	equationStr = strZernike(n, m);
    end
end
function [n, m] = zernike2Noll(zernike)
	nV = [0 1  1 2  2 2  3 3  3 3 4 4  4 4  4  5  5  5  5  5  5 6  6 6  6 6  6 6  7 7  7 7  7 7  7 7 8 8  8 8  8 8  8 8  8 9  9 9  9 9  9 9  9 9  9 10 10 10 10 10 10 10 10 10  10 10 11 11 11 11 11 11 11 11 11 11  11 11 12 12 12 12 12 12 12 12 12 12  12 12  12 13 13 13 13 13 13 13 13 13 13 13  13 13  13];
    mV = [0 1 -1 0 -2 2 -1 1 -3 3 0 2 -2 4 -4  1 -1  3 -3  5 -5 0 -2 2 -4 4 -6 6 -1 1 -3 3 -5 5 -7 7 0 2 -2 4 -4 6 -6 8 -8 1 -1 3 -3 5 -5 7 -7 9 -9  0 -2  2 -4  4 -6  6 -8  8 -10 10 -1  1 -3  3 -5  5 -7  7 -9  9 -11 11  0  2 -2  4 -4  6 -6  8 -8 10 -10 12 -12  1 -1  3 -3  5 -5  7 -7  9 -9 11 -11 13 -13];
 	n= nV(zernike);
 	m =mV(zernike);
end

function equationStr = strZernike(n, m)
    % Return analytic expression for a given Zernike in LaTeX syntax
    signed_m = m;
    m = int16(abs(m));
    n = int16(abs(n));

    terms = {};
    equationStr = '';
    cMax = int16((n - m) / 2)
    [n,m]
    for k=0:cMax
        [k, n, m]
    	coef = ((-1)^k * factorial(n - k) ./ ...
                (factorial(k) * factorial(int16((n + m) ./ 2.) - k) * factorial(int16((n - m) ./ 2.) - k)))

        
        if coef ~= 0
        	if k == 0
        		formatcode = '%d';
        	else
        		formatcode = '%+d';
            end
            tmp = sprintf(strcat(formatcode, '  r^%d '), int16(coef), n - 2 * k);
            equationStr = strcat(equationStr, ' ', tmp);
            
        end

    end

        


    if m == 0
        if n == 0
            equationStr = '1';
        else
        	equationStr = sprintf('\\sqrt{%d}* ( %s )', n+1, equationStr);
        end
    elseif signed_m > 0
    	equationStr = sprintf('\\sqrt{%d}* ( %s ) * \\cos(%d \\theta)', 2 * (n + 1), equationStr,  m);
        
    else
    	equationStr = sprintf('\\sqrt{%d}* ( %s ) * \\sin(%d \\theta)', 2 * (n + 1), equationStr,  m);
    end
end
