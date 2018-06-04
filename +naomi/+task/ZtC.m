function  ZtC(bench)
%ZTC Summary of this function goes here
%   Detailed explanation goes here
global naomiGlobalBench
if nargin<1; bench = naomiGlobalBench; end;
if isempty(bench.IFMData)
  msgbox({'A zernike 2 command matrix can ', 'only be maed after an IFM as bean measured or loaded'});
  return; 
end
% the naomi Zernike To Command
ZtCData = naomi.make.ZtC(bench, bench.IFMData, 'NAOMI_PUPILL');
% the fll dm pupill Zernike To Command
ZtCDmData = naomi.make.ZtC(bench,bench.IFMData , 'DM_PUPILL');
% configure the naomi Zernike to Command in the bench 
naomi.config.ZtC(bench, ZtCData);

naomi.saveData(bench, ZtCData);
% save the spart matrix 
naomi.saveData(bench, ZtCData.toSparta);
naomi.saveData(bench, ZtCDmData);

naomi.plot.figure('ZtC QC');
ZtCData.plotQc;
naomi.saveFigure(bench, ZtCData, 'QC');
end

