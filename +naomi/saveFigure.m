function filePath = saveFigure(bench, data,flavor)
%SAVEFIGURE save the current figure 
%   construct the path according the data attached and the bench instance 
%   the figure extention is taken from bench.config.figureExtentionList;
if isempty(bench)
    bench = [];
    exts = {'png'};
else 
    exts = bench.config.figureExtentionList;
end
for iExt=1:length(exts)
    filePath = sprintf('%s_%s.%s',  naomi.data2path(bench, data), flavor, exts{iExt});
    saveas(gcf, filePath);
    if nargin>1
        bench.log(sprintf('NOTICE: figure saved at %s', filePath));
    end
end

