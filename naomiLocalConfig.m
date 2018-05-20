function  naomiLocalConfig(c)
%localConfig modify all the default parameters at startup 
%   The localConfig is not on svn it allows to modify parameters
%   function to where the program started.
%
% some obvious setting to be changed by localConfig
% c.hasoType = 'haso128'; % od phasecam 
% c.dataDirectory = '/some/directory';
% c.configDirectory = '/other/directory';
%
% see the naomi.Config object for more info
 
 c.simulated = 1;
 c.simulatorIFM = '/Users/guieus/DATA/NAOMI/IFM_direct.fits';
 c.simulatorZtC = '/Users/guieus/DATA/NAOMI/NTC_2018-04-03T11-19-30.fits';
 c.simulatorBias;
 c.simulatorTurbu = '/Users/guieus/DATA/NAOMI/turbu.fits';
end

