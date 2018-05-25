function afterZtP(bench, ZtPData)
%AFTERIFM tasks done  after measuring ZtP
%   save the ZtP data 
%  plot QC

naomi.config.ZtP(bench,ZtPData);

naomi.saveData(ZtPData, bench);
naomi.plot.figure('ZtP QC', 1);
ZtPData.plotQc;
naomi.saveFigure(ZtPData,'QC',  bench);
naomi.plot.figure('ZtP QC Mode', 1);
ZtPData.plotModes;
naomi.saveFigure(ZtPData,'QC_Modes', bench);
end