function autocol = startAutocol(config)
	% Starting the communication with the autocol (only used at IPAG)
	% return it as a Autocol object
	config.log('Starting Autocol communication...', 1);   
    autocol = naomi.objects.Autocol(config.autocolCom);
    config.log('OK\n', 1);
end