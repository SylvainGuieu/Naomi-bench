function filePath = saveData(bench, data)
    
    filePath = naomi.data2path(bench, data);
    filePath = sprintf('%s.fits', filePath);
    if ~isempty(bench)
        bench.log(sprintf('NOTICE: save file to %s', filePath));
    end
    data.saveFits(filePath);
end

