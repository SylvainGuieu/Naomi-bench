function startGimbal(config)
    % Libraries for PI motors control
    global gimbal;
    switch config.location
        case {config.IPAG, config.BENCH} 
            addpath('C:\Users\Public\PI\PI_MATLAB_Driver_GCS2');
            gimbal = naomi.objects.Gimbal('0175500223');
            
        case config.ESOHQ
            %% ADD something to do with motors at ESO-HQ ?
            error('Gimbal motor communication is not established at ESO-HQ');
    end
    gimbal.rX.zero = config.gimbalRxZero;
    gimbal.rY.zero = config.gimbalRyZero;
    gimbal.rX.gain = config.gimbalRxGain;
    gimbal.rY.gain = config.gimbalRyGain;
    gimbal.serialNumber = config.gimbalNumber;
    
end