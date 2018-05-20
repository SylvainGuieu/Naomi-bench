function filePath = saveData(data, bench)
    if nargin<2
        directory = '.';
    else
        directory = bench.config.dataDirectory;
    end

    dateOb = data.getKey(naomi.KEYS.DATEOB, []);
    
    if isempty(dateOb)    
        suffix = datestr(now, 'yyyy-mm-ddThh:MM:SS');
    else
        suffix = datestr(dateOb, 'yyyy-mm-ddThh:MM:SS');
    end
    
    dprtType = data.getKey(naomi.KEYS.DPRTYPE, 'UNKNOWN');
    
    filePath = fullfile( directory, sprintf('%s_%s.fits', dprtType, suffix));
    %%% :TODO:  save the file and put the right directory !!!! 
    
end

