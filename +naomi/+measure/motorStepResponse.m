function movementArray = motorStepResponse(gimbal, autocol, direction, config)
	

	startX = config.gimbalRxZero; 
    startY = config.gimbalRyZero; 
    step   = config.gimbalRampStep;
    dt = 1;
    
    measurement = naomi.data.AutocolMeasurement([], {}, {gimbal,autocol});
    measurement.initPlot;
    for j=1:10
            [a,b] = autocol.getAllXY();
            measurement.data = [a,b];
            measurement.plot;
            pause(0.1);
    end
end