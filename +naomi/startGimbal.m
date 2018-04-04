function gimbal = startGimbal(config)
    % Starting communication with the motors of DM mount 
    % return it as a Gimbal object
    config.log('Starting CO mount gimbal motors ...',1)
    switch config.getLocation()
        case {config.IPAG, config.BENCH} 
            addpath('C:\Users\Public\PI\PI_MATLAB_Driver_GCS2');
            gimbal = naomi.objects.Gimbal('0175500223');
            
        case config.ESOHQ
            %% ADD something to do with motors at ESO-HQ ?
            config.log('Error Gimbal motor communication is not established at ESO-HQ');
            return ;
    end
    gimbal.rX.zero = config.gimbalRxZero;
    gimbal.rY.zero = config.gimbalRyZero;
    gimbal.rX.gain = config.gimbalRxGain;
    gimbal.rY.gain = config.gimbalRyGain;
    gimbal.serialNumber = config.gimbalNumber;
    config.log('OK\n', 1);
end