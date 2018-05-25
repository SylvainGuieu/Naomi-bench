function filePath = saveFigure(data,flavor, bench)
%SAVEFIGURE save the current figure 
%   construct the path according the data attached and the bench instance 
%   the figure extention is taken from bench.config.figureExtentionList;
if nargin<2
    bench = [];
    exts = {'png'};
else 
    exts = bench.config.figureExtentionList;
end
for iExt=1:length(exts)
    filePath = sprintf('%s_%s.%s',  naomi.data2path(data, bench), flavor, exts{iExt});
    saveas(gcf, filePath);
    if nargin>1
        bench.log(sprintf('NOTICE: figure saved at %s', filePath));
    end
end

