function environment = newEnvironment(config)
	% start communication with temperatur sensor and fan control 
	% and return it as an environment object		
	environment = naomi.objects.Environment();
  environment.connect;
end