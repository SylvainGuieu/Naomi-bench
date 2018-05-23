function dm = newDm(config)
    global naomiGlobalDm
    % start dm capability for naomi 
    % supositely startACE() has been executed before   	
    naomiGlobalDm = acewfcDM_ASDK(config.dmId);
    naomiGlobalDm.Reset();
    naomiGlobalDm.Online();
    naomiGlobalDm.Reset();
    dm = naomiGlobalDm;
end