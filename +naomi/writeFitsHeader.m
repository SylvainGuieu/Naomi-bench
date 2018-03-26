{{'location',       'ORIGIN',  'Where data has been taken IPAG/ESO-HQ/BENCH'},
 {'mjd',            'MJD-OBS', 'Modified Julian Date of writing header'},
 {'dmID',           'DM-ID' ,  'DM identification'},
 {'pupillDiameter', 'PUPDIAM', 'Pupill Diamter [m]'},
 {'xPixelScale',    'XPCALE',  'X pixel scale in m/pixel'},
 {'yPixelScale',    'YPCALE',  'Y pixel scale in m/pixel'},
 {'dmCenterAct',    'CENTACT', 'DM center actuator number'},
 {'xCenter',        'XCENTER', 'DM X center [pixel]'}, 
 {'yCenter',        'YCENTER', 'DM Y center [pixel]'}, 
 {'centerNpp',      'CTNPP',   'Number of push/pull for IFC computation'},
 {'centerAmplitude','CTAMP',   'push/pull amplitude for IFC computation'}, 
 {'scaleNpp',       'SCNPP',   'Number of push/pull for scale computation'}, 
 {'scaleAmplitude', 'SCAMP',   'push/pull amplitude for scale computation'}, 
 {'referenceNp',    'RFNP',    'Number of push for flat/reference measurement'},
 {'rXOrder',        'RXORDER', 'Zernike order or rx motor movement'},
 {'rYOrder',        'RYORDER', 'Zernike order or ry motor movement'},
 {'rXSign',         'RXSIGN',  'Zernike sign or rx positive motor movement'},
 {'rYSign',         'RYSIGN',  'Zernike sign or ry positive motor movement'}
 }
function writeFitsHeader(varargin) 
    % write fits header from a seri of naomi object.
    %
    % exemple 
    % writeFitsHeader( f, config, bench)
    % will write all the keys related to the configuration and bench state
    if nargin<1
        error('Missing first argument as file');
    end
    f = varargin{1};
    
    for i=2:nargin
        obj = varargin{i};
        try
            propDef = getfield(obj, 'propDef');
        catch 
            continue
        end
        
        for j=1:length(propDef)
            def = propDef{j};
            fits.writeKey(f, def{2}, obj.(def{1}), def{3});
        end
    end
end
        
        