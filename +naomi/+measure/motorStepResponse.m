function [motorPositionVector, angleVector, zernikeVector] = motorStepResponse(bench, axis, step, nStep)
    if nargin<3; step = 0.2e-3; end
    if nargin<4; nStep = 10; end
    
    switch axis
        case 'rX'
            switch bench.config.rXOrder
                case 'tip'
                    zernike = 2;
                    zernikeName = 'tip';
                case 'tilt'
                    zernike = 3;
                    zernikeName = 'tilt';
            end
        case 'rY'
            switch bench.config.rYOrder
                case 'tip'
                    zernike = 2;
                    zernikeName = 'tip';
                case 'tilt'
                    zernike = 3;
                    zernikeName = 'tilt';
            end
        otherwise 
            error('axis should be "rX" or "rY" got %s', axis);
    end
    
    
    if bench.isDm
        if ~bench.isCentered 
            bench.log('WARNING: dm was not aligned');
        end
        xCenter = bench.xCenter;
        yCenter = bench.yCenter;
    else
        if ~bench.isAligned
            bench.log('WARNING: mirror was not aligned');
        end
        xCenter = bench.xPupillCenter;
        yCenter = bench.yPupillCenter;
    end
    
    [mask, ~, ~, ~, ~, orientation] = bench.ztcParameters('DM_PUPILL', 'pixel');
    maskMeter = naomi.convertMaskUnit(mask, 'm', bench.meanPixelScale);
    
    [~,PtZ] = naomi.compute.theoriticalZtP(bench.nSubAperture,xCenter,yCenter,mask{1},mask{2}, 3, orientation, bench.dmAngle);
    
    motorPositionVector = zeros(nStep, 1);
    zernikeVector = zeros(nStep,1);
    angleVector = zeros(nStep, 1);
    motorPosition = 0.0;
    
    
    if bench.config.plotVerbose
       naomi.plot.figure('Motor Step Rsponse');
       cla;
    end
    
    for iStep=1:nStep
        phaseArray = naomi.measure.phase(bench,1,0,[],0); % one phase, not tt removal, no mask
        zer = naomi.compute.nanzero(phaseArray(:)') * reshape(PtZ,[],3);
        
        arcsec = zer(zernike) * 1e-6 * 4/2 /  maskMeter{1} / 4.8e-6;
         
        motorPositionVector(iStep) = motorPosition;
        zernikeVector(iStep) = zer(zernike);
        angleVector(iStep) = arcsec;
        
        bench.gimbal.moveBy(axis, step);
        motorPosition = motorPosition + step;
        
        
        if bench.config.plotVerbose
            
            naomi.plot.figure('Motor Step Rsponse'); clf;
            plot( motorPositionVector(1:iStep)*1000, angleVector(1:iStep), 'k+');
            
        end
    end
    
    
    if bench.config.plotVerbose  
        p = polyfit(motorPositionVector*1000,  angleVector, 1);
        naomi.plot.figure('Motor Step Rsponse'); clf;
        subplot(2,1,1);
        plot( motorPositionVector(1:iStep)*1000, angleVector(1:iStep), 'k+');
        hold on;
        x = [min(motorPositionVector), max(motorPositionVector)]*1000;
        plot(x, p(1)*x+p(2), 'b-');
        hold off;
        legend('', sprintf('gain %.3f arcsec/mu', p(1)), 'Location','northwest');
        title(sprintf('axis: %s (%s)', axis, zernikeName));
        
        ylabel(sprintf('Mechanical %s (arcsec)', zernikeName));
        subplot(2,1,2);
        residualVector = angleVector - (p(1)*motorPositionVector*1000+p(2));
        plot(motorPositionVector*1000, residualVector, 'k+');
        xlabel('Motor (\mum)');
        ylabel('Residuals (arcsec)');
        legend(sprintf('rms %.2f', std(residualVector(:))));
    end
    
end