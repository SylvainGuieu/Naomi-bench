function ACEStatus = startACE(config)    
	% start the Alpao Core Engine for naomi
	% return true if everything went correctly
	ACEStatus = false;
	naomi.log('Starting the ACE environment \n', 1, config.verbose);	
  setenv('ACEROOT', config.ACEROOT);
  addpath(fullfile(getenv('ACEROOT'), 'matlab'));
  acecsStartup();
  ACEStatus = true;
	naomi.log('ACE environment', 1, config.verbose);	
end