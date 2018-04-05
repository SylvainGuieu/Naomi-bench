function [file, path] = askFitsFile(msg)
	if nasrgin<1; msg = 'Select a *.fits file';
	[file, path] = uigetfile('*.fits', msg);
end
