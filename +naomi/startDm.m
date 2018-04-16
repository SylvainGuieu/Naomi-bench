function dm = startDm(config)
    % start dm capability for naomi 
    % supositely startACE() has been executed before   	
    config.log('Instantiate DM ...', 1);
    dm = acewfcDM_ASDK(config.dmID);
    dm.Reset();
    config.log('OK\n', 1);
end