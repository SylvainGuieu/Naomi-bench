function start(config)
    % load all the modules necessary for the scripts to work
    % config is the bench configureration created by naomi.Config()
    global wfs 
    global dm 
    global gimbal;
    global reference;
    
    fprintf('\n\n-------------------\n');
    fprintf('  Start NAOMI bench  \n');
    fprintf('-------------------\n\n');

    %% Global configuration
    naomi.startGimbal(config);
    naomi.startACE(config);
    naomi.startWfs(config);
    % Create today folder
    mkdir(config.todayDirectory);
    
    dmId = config.getDmId();% this will ask for dmId if not set
    switch dmId
        case "DUMMY"
            naomi.startReference(wfs, config);
            
        otherwise
            naomi.startDM(config);
            naomi.startAO(wfs, dm, config);
        
    


end