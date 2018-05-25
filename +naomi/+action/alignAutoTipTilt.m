function [dTip,dTilt] = alignAutoTipTilt(bench, gain, pupillDiameter, timeout)
    % timeout in second default is 60
    if nargin<2; gain =  bench.config.pupillTipTiltAlignGain;end
    if nargin<3; pupillDiameter = bench.config.fullPupillDiameter;end
	if nargin<4; timeout = 60; end
	
    % convert time out in day
    timeout = timeout/(24*3600);
	tiltThreshold = bench.config.pupillTipTiltThresholdAuto;
	bench.log('NOTICE: autoalignment started');
	
	[~,~,dTip,dTilt,~] = naomi.measure.missalignment(bench);
    startTime = now;
    bench.registerProcess('alignAutoTipTilt');
    
	while ~checkAlign(dTip,dTilt, tiltThreshold)
		if bench.isProcessKilled('alignAutoTipTilt')
            bench.log('NOTICE: autoalignment finished');
            return 
        end
        if (now-startTime) > timeout 
            bench.log('ERROR: autoalignment failed -> timeout');
            break
        end
		
		[~,~,dTip,dTilt,~] = naomi.measure.missalignment(bench);
        
        axisTip = bench.axisMotor('tip');
        sTip = bench.axisSign('tip');
        %                             |- micron to meter
        %                             |     |- rms to pic-to-valey
        %                             |     | |- mecanical to optical angle
        %                             |     | |                    |- rad to arcsec /4.8e-6
        tipArcsec = -gain*sTip*dTip * 1e-6 *4/2 / pupillDiameter / 4.8e-6;
        bench.gimbal.moveByArcsec(axisTip, tipArcsec);
        
        
        axisTilt = bench.axisMotor('tilt');
        sTilt = bench.axisSign('tilt');
        tiltArcsec =  -gain*sTilt*dTilt * 1e-6 *4/2 / pupillDiameter / 4.8e-6;
        bench.gimbal.moveByArcsec(axisTilt, tiltArcsec);
        bench.log(sprintf('NOTICE: moving gimbal by %.2f in tip and %.2f arcsec in tilt', tipArcsec, tiltArcsec));
        pause(0.5); % leave a bit of space for graphical process 
    end
    bench.killProcess('alignAutoTipTilt');
end

function test = checkAlign(dTip,dTilt, tiltThreshold)
	test = (dTip^2+dTilt^2) <= (tiltThreshold^2);
end
