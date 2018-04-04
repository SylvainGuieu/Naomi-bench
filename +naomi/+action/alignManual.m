function [dX,dY,dTip,dTilt,dFoc] = alignManual(bench)
	
	
	tiltThreshold = bench.config.pupillTipTiltThresholdManual;
	pupThreshold = bench.config.pupillCenteringThreshold;
	

	PHASE = naomi.measure.phase(bench);
	[dX,dY,dTip,dTilt,dFoc] = naomi.measure.missalignment(bench, PHASE.data);

	if ~checkAlign(dX,dY,dTip,dTilt, pupThreshold, tiltThreshold)
		choice = questdlg({'Alignement is recommended','Do you want to align?'}, ...
	                        'Alignement', 'Yes', 'No','Yes');
        if strcmp(choice,'No') return; end;
	end


	while ~checkAlign(dX,dY,dTip,dTilt, pupThreshold, tiltThreshold)
		
		PHASE = naomi.measure.phase(bench);
		[dX,dY,dTip,dTilt,dFoc] = naomi.measure.missalignment(bench, PHASE.data);
		naomi.getFigure('Alignment');
		PHASE.plot();
		title({'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
               sprintf('Adjust x,y and tip,tilt to be <%.2fpix and <%.2fum',pupThreshold,tiltThreshold),
               sprintf('Current:           x=%.2f  y=%.2f  tip=%.2f  tilt=%.2f',...
                       dX, dY, dTip, dTilt),
               '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'});

    end
    uiwait(msgbox(sprintf('Alignement is OK\n')));
    naomi.getFigure('Alignment'); clf; close;
end

function test = checkAlign(dX,dY,dTip,dTilt, pupThreshold, tiltThreshold)
	test = ((dX^2+dY^2)<= pupThreshold^2) && ((dTip^2+dTilt^2) <= tiltThreshold^2);
end

