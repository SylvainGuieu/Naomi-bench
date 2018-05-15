function [dTip,dTilt] = alignAutoTipTilt(bench, gain, pupillDiameter, timeout)
    % timeout in second default is 60
    if nargin<2; gain =  bench.config.pupillTipTiltAlignGain;end
    if nargin<3; pupillDiameter = bench.config.fullPupillDiameter;end
	if nargin<4; timeout = 60; end
	
    % convert time out in day
    timeout = timeout/(24*3600);
	tiltThreshold = bench.config.pupillTipTiltThresholdAuto;
	
	
	[~,~,dTip,dTilt,~] = naomi.measure.missalignment(bench);
    startTime = now;
    bench.registerProcess('alignAutoTipTilt');
    
	while ~checkAlign(dTip,dTilt, tiltThreshold)
		if bench.isProcessKilled('alignAutoTipTilt')
            bench.config.log('autoalignment killed');
            return 
        end
        if (now-startTime) > timeout 
            bench.config.log('ERROR: autoalignment failed -> timeout');
            break
        end
		
		[~,~,dTip,dTilt,~] = naomi.measure.missalignment(bench);
        
        axisTip = bench.axisMotor('tip');
        sTip = bench.axisSign('tip');
        bench.gimbal.moveByArcsec(axisTip,  -gain*sTip*dTip * 1e-6 *4/2 / pupillDiameter / 4.8e-6);
        
        axisTilt = bench.axisMotor('tilt');
        sTilt = bench.axisSign('tilt');
        bench.gimbal.moveByArcsec(axisTilt,  -gain*sTilt*dTilt * 1e-6 *4/2 / pupillDiameter / 4.8e-6);
        pause(0.1); % leave a bit of space for graphical process 
    end
    bench.killProcess('alignAutoTipTilt');
end

function test = checkAlign(dTip,dTilt, tiltThreshold)
	test = (dTip^2+dTilt^2) <= (tiltThreshold^2);
end
