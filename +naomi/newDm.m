function dm = newDm(config)
    % start dm capability for naomi 
    % supositely startACE() has been executed before   	
    dm = acewfcDM_ASDK(config.dmId);
    dm.Reset();
end