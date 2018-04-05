function [file, path] = askFitsFile(msg)
	if nargin<1; msg = 'Select a *.fits file';end
	[file, path] = uigetfile('*.fits', msg);
end
