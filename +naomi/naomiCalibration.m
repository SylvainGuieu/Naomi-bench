%naomiCalibration.m

todayDirectory = bench.config.todayDirectory

% set the tplName for the following measurements 
tplName = bench.config.tplName;
bench.config.tplName = 'CALIBRATE';

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

startDate = now;

% Setup WFS on a large pupil, remove any mask 
naomi.config.mask(bench, []);
naomi.action.resetWfs(bench);
naomi.action.resetDm(bench);

% Ask the ifMode measurement calibration 
bench.config.getIfMode(); % this will bring a gui if the mode is not set yet

% measure the IFM
[IFMData, IFMcleanData] =  naomi.measure.IFM(bench);

naomi.action.resetDm(bench);

% save the IFM matrixes 
IFMData.saveFromDate(todayDirectory, startDate);
IFMCleanData.saveFromDate(todayDirectory, startDate);
% convert to a sparta and save it
IFMCleanData.toSparta().saveFromDate(todayDirectory, startDate);

% configure the IFM inside the bench, this should be the clean one
naomi.config.IFM(bench, IFMCleanData);
% make the Zernike to command matrix from the stored IFM 
ZtCData = naomi.make.ZtC(bench);

ZtCData.saveFromDate(todayDirectory, startDate);
ZtCData.toSparta().saveFromDate(todayDirectory, startDate);


