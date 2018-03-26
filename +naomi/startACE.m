function startACE(config)
    global ACEStatus;
    if isempty(ACEStatus) || ~ACEStatus
          % start the Alpao Core Engine for naomi
          setenv('ACEROOT', config.ACEROOT);
          addpath(fullfile(getenv('ACEROOT'), 'matlab'));
          acecsStartup();
          ASEStatus = true;
end