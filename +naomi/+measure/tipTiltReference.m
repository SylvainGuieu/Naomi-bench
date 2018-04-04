function [tip,tilt] = tipTiltReference(bench)
	wfs = bench.wfs;
	wfs.resetTipTiltReference();
	
	[tip,tilt] = wfs.getTipTilt();
	if bench.config.autoConfig
		bench.config.log('Removing the main Tip/Tilt\n', 1);
		wfs.removeTipTilt(tip, tilt);
	end
end