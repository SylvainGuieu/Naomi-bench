function IFM(bench)
%MEASUREIFM Measure a IFM, clean it and load it to the bench and save it
%  IFM qc plot are also saved
global naomiGlobalBench
if nargin<1; bench = naomiGlobalBench; end;

IFMData = naomi.measure.IFM(bench);
naomi.task.afterIFM(bench, IFMData);
end



