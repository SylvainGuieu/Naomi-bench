function autocol = newAutocol(config)
	% Starting the communication with the autocol (only used at IPAG)
	% return it as a Autocol object
	naomi.log('Starting Autocol communication...', 1, config.verbose);   
  autocol = naomi.objects.Autocol(config.autocolCom);
  naomi.log('OK\n', 1, config.verbose);
end