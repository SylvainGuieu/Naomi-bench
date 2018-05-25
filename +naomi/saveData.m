function filePath = saveData(data, bench)
    if nargin<2; bench = []; end
    filePath = naomi.data2path(data, bench);
    filePath = sprintf('%s.fits', filePath);
    if nargin>1
        bench.log(sprintf('NOTICE: save file to %s', filePath));
    end
    data.saveFits(filePath);
end

