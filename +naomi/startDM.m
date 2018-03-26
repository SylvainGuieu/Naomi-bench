function startDM(config)
    % start dm capability for naomi 
    % supositely startACE has been executed before 
    global dm;
    
    naomi.startACE(config);
    fprintf('Instantiate DM\n');
    
    dm = acewfcDM_ASDK(config.dmID);
    dm.Reset();
    
end