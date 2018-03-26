function startAO( config)
    global ao;
    global wfs;
    global dm;
    
    
    if isempty(wfs)
        naomi.startWfs(config);
    end
    if isempty(dm)
        naomi.startDM(config);
    end
    
    ao = naomi.objects.AO(wfs, dm, config);
    ao.saveReference(config);

     % Make DM online 
    dm.Online();
    dm.StartMonitoring();
     % Load DM bias
    fprintf('Set bias to 0.0\n');
    dm.biasVector = 0.0;
    dm.Reset();

    ao.measureScale(config);
    % compute center and save it as fits file 
    ao.saveIFCenter(config);
