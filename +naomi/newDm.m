function dm = newDm(config)
    % start dm capability for naomi 
    % supositely startACE() has been executed before   	
    config.log('Instantiate DM ...', 1);
    dm = acewfcDM_ASDK(config.dmId);
    dm.Reset();
    config.log('OK\n', 1);
end