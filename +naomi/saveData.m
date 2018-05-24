function filePath = saveData(data, bench)
    if nargin<2
        directory = '.';
    else
        directory = bench.config.sessionDirectory;
    end

    dateOb = data.getKey(naomi.KEYS.DATEOB, []);
    
    if isempty(dateOb)    
        suffix = datestr(now, 'yyyy-mm-ddThh-MM-SS');
    else
        suffix = datestr(dateOb, 'yyyy-mm-ddThh-MM-SS');
    end
    
    dprtType = data.getKey(naomi.KEYS.DPRTYPE, 'UNKNOWN');
    
    dprVer = data.getKey(naomi.KEYS.DPRVER, '');
    if dprVer; dprVer = strcat('_', dprVer);end
    
    filePath = fullfile( directory, sprintf('%s%s_%s.fits', dprtType, dprVer, suffix));
    if nargin>1
        bench.log(sprintf('NOTICE: save file to %s', filePath));
    end
        
    data.saveFits(filePath);
    
end

