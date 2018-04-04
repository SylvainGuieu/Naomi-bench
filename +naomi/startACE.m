function ACEStatus = startACE(config)    
	% start the Alpao Core Engine for naomi
	% return true if everything went correctly
	ACEStatus = false;
	config.log('Starting the ACE environment ... ', 1);	
  	setenv('ACEROOT', config.ACEROOT);
  	addpath(fullfile(getenv('ACEROOT'), 'matlab'));
  	acecsStartup();
  	ACEStatus = true;
  	config.log('OK\n', 1);  	
end