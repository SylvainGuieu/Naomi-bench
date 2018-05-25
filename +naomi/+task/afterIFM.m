function afterIFM(bench, IFMData)
%AFTERIFM tasks to do after measuring IFM
%   clean the IFM 
%   set the cleaned IFM to the bench 
%   create a Zernike to command and set it to the bench
%   save IFM, IFM cleaned and ZtC and ZtC for Sparta

IFMCleanData = naomi.make.cleanIFM(bench, IFMData);
naomi.config.IFM(bench,IFMCleanData);

naomi.saveData(IFMData, bench);
naomi.saveData(IFMCleanData, bench);
naomi.plot.figure('IFM QC', 1);
IFMCleanData.plotQc;
naomi.saveFigure(IFMCleanData,'QC',  bench);
end
%     IFMCleanData = naomi.make.cleanIFM(bench, IFMData);
%     naomi.config.IFM(bench,IFMCleanData);
%     ZtCData = naomi.make.ZtC(bench, IFMCleanData, 'naomi-pup');
%     ZtCDmData = naomi.make.ZtC(bench, IFMCleanData, 'dm-pup');
%     naomi.config.ZtC(bench, ZtCData);
%     
%     naomi.saveData(IFMData, bench);
%     naomi.saveData(IFMCleanData, bench);
%     naomi.saveData(ZtCData,bench);
%     naomi.saveData(ZtCDmData,bench);
%     naomi.saveData(ZtCData.toSparta, bench);
%     
%     [~, dmBiasData] = naomi.measure.dmBias(bench);
%     naomi.config.bias(bench, dmBiasData);
%     naomi.saveData(dmBiasData,bench);
%     
% end

