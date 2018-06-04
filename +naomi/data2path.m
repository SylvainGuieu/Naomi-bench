function filePath = data2path(bench, data)
%DATA2PATH from a naomi.data objects and the bench
%    create a path (without extention) and return it
   if isempty(bench)
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
    
    filePath = fullfile( directory, sprintf('%s%s_%s', dprtType, dprVer, suffix));
   

end

