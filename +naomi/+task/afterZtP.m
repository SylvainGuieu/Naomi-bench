function afterZtP(bench, ZtPData)
%AFTERIFM tasks done  after measuring ZtP
%   save the ZtP data 
%  plot QC

naomi.config.ZtP(bench,ZtPData);

naomi.saveData(bench, ZtPData);
naomi.plot.figure('ZtP QC', 1);
ZtPData.plotQc;
naomi.saveFigure(bench, ZtPData,'QC');
naomi.plot.figure('ZtP QC Mode', 1);
ZtPData.plotModes;
naomi.saveFigure(bench, ZtPData,'QC_Modes');
end