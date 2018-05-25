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
ZtCData = naomi.make.ZtC(bench, bench.IFMData, 'naomi-pup');
% the fll dm pupill Zernike To Command
ZtCDmData = naomi.make.ZtC(bench,bench.IFMData , 'dm-pup');
% configure the naomi Zernike to Command in the bench 
naomi.config.ZtC(bench, ZtCData);

naomi.saveData(ZtCData,bench);
naomi.saveData(ZtCDmData,bench);

naomi.plot.figure('ZtC QC');
ZtCData.plotQc;
naomi.saveFigure(ZtCData, 'QC', bench);
end

