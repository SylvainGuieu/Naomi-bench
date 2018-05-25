function [file, path] = askFitsFile(msg, bench)
	if nargin<1; msg = 'Select a *.fits file';end
    if nargin<2
        [file, path] = uigetfile('*.fits', msg);
        return 
    end
    
    curentDir = pwd;
    cd(bench.config.todayDirectory);
    [file, path] = uigetfile('*.fits', msg);
    cd(curentDir);
end
