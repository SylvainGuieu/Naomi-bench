function strokes(bench)
%STROKES measure the stroke of tip and tilt plot QC and save it 
global naomiGlobalBench;
if nargin<1; bench=naomiGlobalBench;end

if ~isempty(bench.ZtCData) 
    obdate =  bench.ZtCData.getKey(naomi.KEYS.DATEOB, now);
else 
    obdate = now;
end
sTipData = naomi.measure.stroke(bench, 2);
sTipData.setKey(naomi.KEYS.DATEOB,obdate , naomi.KEYS.DATEOBc);
naomi.saveData(bench, sTipData);
naomi.plot.figure('TIP QC');
sTipData.plotQc;
naomi.saveFigure(bench, sTipData, 'QC');

sTiltData = naomi.measure.stroke(bench, 3);
sTiltData.setKey(naomi.KEYS.DATEOB,obdate , naomi.KEYS.DATEOBc)
naomi.saveData(bench, sTiltData);
naomi.plot.figure('TILT QC');
sTiltData.plotQc;
naomi.saveFigure(bench, sTiltData, 'QC');

end

