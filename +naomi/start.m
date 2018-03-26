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
    
    dmID = config.getDmID();% this will ask for dmID if not set
    switch dmID
        case "DUMMY"
            naomi.startReference(wfs, config);
            
        otherwise
            naomi.startDM(config);
            naomi.startAO(wfs, dm, config);
        
    


end