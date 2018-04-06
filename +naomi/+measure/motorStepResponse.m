function movementArray = motorStepResponse(bench, direction)
	
    config = bench.config;
    gimbal = bench.gimbal;
    autocol = bench.autocol;
    
    
	startX = config.gimbalRxZero; 
    startY = config.gimbalRyZero; 
    step   = config.gimbalRampStep;
    N = config.gimbalRampPoints;
    direction = upper(direction);
    dt = 1;
    


    oneMeasurement = naomi.data.AutocolMeasurement([], {}, {gimbal,autocol});
    measurement = naomi.data.AutocolSequence([], {}, {gimbal,autocol});
    
    
    % empty the buffer first by taking several 
    % oneMeasurement
    for j=1:10
            [a,b] = autocol.getAllXY();
            oneMeasurement.data = [a,b];
            oneMeasurement.update(); % update the header keyword
            bench.config.figure('autocol alpha');
            oneMeasurement.plotAlpha;   % plot it
            bench.config.figure('autocol beta');
            oneMeasurement.plotBeta;   % plot it
            pause(0.1);
    end
    % for i=1:N
    %     for j=1:4 % skip the 3 first oneMeasurement in buffer and keep the last
    %         [a,b] = autocol.getAllXY();
    %         oneMeasurement.data = [a,b];
    %         oneMeasurement.update(); % update the header keyword
    %         bench.config.figure('autocol alpha');
    %         oneMeasurement.plotAlpha;   % plot it
    %         bench.config.figure('autocol beta');
    %         oneMeasurement.plotBeta;   % plot it
    %     end;

end