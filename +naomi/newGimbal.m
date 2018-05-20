function gimbal = newGimbal(config)
    % Starting communication with the motors of DM mount 
    % return it as a Gimbal object
    config.log('Starting CO mount gimbal motors ...',1);
    addpath(config.piMotorDriver);
    gimbal = naomi.objects.Gimbal(config.piControlerSerial);
    
    gimbal.rX.zero = config.gimbalRxZero;
    gimbal.rY.zero = config.gimbalRyZero;
    gimbal.rX.gain = config.gimbalRxGain;
    gimbal.rY.gain = config.gimbalRyGain;
    gimbal.serialNumber = config.gimbalNumber;
    config.log('OK\n', 1);
end