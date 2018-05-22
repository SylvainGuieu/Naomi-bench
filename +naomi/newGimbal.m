function gimbal = newGimbal(config)
    % Starting communication with the motors of DM mount 
    % return it as a Gimbal object
    addpath(config.piMotorDriver);
    gimbal = naomi.objects.Gimbal(config.piControlerSerial);
    gimbal.rX.zero = config.gimbalRxZero;
    gimbal.rY.zero = config.gimbalRyZero;
    gimbal.rX.gain = config.gimbalRxGain;
    gimbal.rY.gain = config.gimbalRyGain;
    gimbal.serialNumber = config.gimbalNumber;    
end