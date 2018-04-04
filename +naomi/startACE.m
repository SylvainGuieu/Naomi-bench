function ACEStatus = startACE(config)    
	% start the Alpao Core Engine for naomi
	% return true if everything went correctly
	ASEStatus = false;
	config.log('Starting the ACE environment ... ', 1);	
  	setenv('ACEROOT', config.ACEROOT);
  	addpath(fullfile(getenv('ACEROOT'), 'matlab'));
  	acecsStartup();
  	ASEStatus = true;
  	config.log('OK\n', 1);  	
end