function environment = startEnvironment(config)
	% start communication with temperatur sensor and fan control 
	% and return it as an environment object	
	config.log('Starting temperature sensors and fan controls ...', 1);
	environment = naomi.objects.Environment();
    environment.connect;
	config.log('OK\n');
end