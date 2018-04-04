function log(str, level, configLevel)
	% naomi.log(str, level, configLevel)
	% log a message (fprintf for now) if level<=configLevel 
	% if configLevel is not given, log the message if level>0
	% if level is not given, log the message 
	if nargin<3
		test = level;
	elseif nargin<2
		test = 1;
	elseif nargin==3
		test = level<=configLevel;
	end
	if test; fprintf(str); end
end