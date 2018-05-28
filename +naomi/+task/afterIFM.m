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