
todayDirectory = bench.config.todayDirectory

tplName = bench.config.tplName;
bench.config.tplName = 'VALIDATE';

if ~naomi.config.IFC(bench)
	naomi.alignManual(bench);
	naomi.config.IFC(bench, 'measure');
end
if ~naomi.config.pixelScale(bench)
	naomi.config.pixelScale(bench, 'measure');
end

if ~naomi.config.ZtC(bench) % user fetch a Zernique to command if need 
	naomi.config.ZtC(bench, 'fetch'); 
end

startDate = now;

naomi.config.mask(bench, []); % remove the mask 
naomi.measure.ZtP(bench).saveFromDate(todayDirectory, startDate);

naomi.config.pupillMask(bench); % set the pupill mask as set in config

% record a flat in open loop and save it 
openFlatData = naomi.measure.openFlat(bench)
openFlatData.saveFromDate(todayDirectory, startDate);

% record a flat in close loop and save it
closeFlatData = naomi.measure.closeFlat(bench)
closeFlatData.saveFromDate(todayDirectory, startDate);

% measure the stroke for the tip and save it 
tipStrokeData = naomi.measure.stroke(bench,2)
tipStrokeData.saveFromDate(todayDirectory, startDate);

% measure the stroke for the tilt and save it 
tiltStrokeData = naomi.measure.stroke(bench,3)
tiltStrokeData.saveFromDate(todayDirectory, startDate);

% put back the tplName to what it was 
bench.config.tplName = tplName;