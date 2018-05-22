
todayDirectory = bench.config.todayDirectory

% set the tplName for the following measurements 
tplName = bench.config.tplName;
bench.config.tplName = 'VALIDATE';

% check if the bench has been aligned, if not align it
if ~bench.isAligned
	if bench.has('gimbal')
		 	naomi.alignAuto(bench);
	else
		naomi.alignManual(bench);
	end
	[~,IFCData] = naomi.measure.IFC(bench);
	naomi.config.IFC(IFCData); % this will alos set the xCenter,yCenter
end

% check if pixel scale has been computed if not measure it 
if ~bench.isScaled
	[xScale, yScale] = naomi.measure.pixelScale(bench);
	naomi.config.pixelScale(bench, xScale, yScale);
end

if ~bench.isZtPCalibrated % user fetch a Zernique to command file if needed 
	naomi.config.ZtC(bench); % withtout further argument a gui ask user to fetch a file
end


startDate = now;

naomi.config.mask(bench, []); % remove the mask 
ZtPData = naomi.measure.ZtP(bench); % measure the Zernique to Phase for NAOMI
ZtPData.saveFromDate(todayDirectory, startDate); % save the Z2P file 

% set the Naomi pupill mask as described in config
% ztcNeigenValue = 140; ztcNzernike = 100;
naomi.config.pupillMask(bench, bench.config.ztcMask); 

% record a flat in open loop and save it 
[~,openFlatData] = naomi.measure.openFlat(bench);
openFlatData.saveFromDate(todayDirectory, startDate);

% record a flat in close loop and save it
[~,closeFlatData] = naomi.measure.closeFlat(bench);
closeFlatData.saveFromDate(todayDirectory, startDate);

% measure the stroke for the tip and save it 
tipStrokeData = naomi.measure.stroke(bench,2);
tipStrokeData.saveFromDate(todayDirectory, startDate);

% measure the stroke for the tilt and save it 
tiltStrokeData = naomi.measure.stroke(bench,3);
tiltStrokeData.saveFromDate(todayDirectory, startDate);

% put back the tplName to what it was 
bench.config.tplName = tplName;