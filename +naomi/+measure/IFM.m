function [IFM, IFMcleaned, NtC] = IFM(bench, Npp, Nloop, Amp, IFPause, Neig, Nzern)
%   measure.IFM  Get the Influence Function of all actuators 
% 
%   IFM = measure.IFM(bench, Npp, Nloop, Amp, IFPause)
%
%   The requested actuator is push-pulled and the difference
%   is returned as its influence function. The Amp is reversed
%   between each loop (to reverse creep).
% 
%   bench: naomi bench structure including wfs and dm object
%   
%   Npp: number of push-pull
%   Nloop: Number of loop across actuator (recommended 2)
%   Amp: amplitude of the push-pull
%   IFPause: pause before starting next actuator
%   Neig : numberof  Eigen values for NtC computation
%   Nzern: number of zernics for NtC computation 
% 
%   IFM : the influence functions 
%   IFMClean : the cleaned influence functions
%   NtC : NAOMI to Command Matrix

% Size

	config = bench.config;
	mjd =  config.mjd;

	if nargin<2; Npp = config.ifNpp; end
	if nargin<3; Nloop = config.ifNloop; end
	if nargin<4; Amp   = config.ifAMplitude; end
	if nargin<5; IFPause  = config.ifPause; end
	if nargin<6; Neig  = config.ntcNeig; end
	if nargin<7; Nzern  = config.ntcNzern; end

	wfs = bench.wfs;
	dm  = bench.dm;

	Nact = dm.nAct;
	Nsub = wfs.Nsub;
	IFMarray = zeros(Nact,Nsub,Nsub);

	% Loop
	for l=1:Nloop
	    
	    % Loop on actuators
	    for i=1:Nact
	        IFarray = naomi.measure.IF(bench, i, Npp, Amp).data;
	        IFMarray(i,:,:) = IFMarray(i,:,:) + reshape(IFarray,1,Nsub,Nsub) / Nloop;
	        pause(IFPause);
	    end
	    
	    % Reverse amplitude (push-pull -> pull-push)
	    Amp = -Amp;
	end

	h = {{'MJD-OBS' ,mjd, 'modified julian when script started'},
		 {'IF_AMP'  ,Amp,'[Cmax] amplitude of push-pull'},
	     {'IF_NPP'  ,Npp,'number of push-pull'},
	     {'IF_LOOP' ,Nloop,'number of push-pull'},
	     {'IF_PAUSE',IFPause,'pause between actioneu'}};

	IFMData = naomi.data.IFM(IFMarray, h , {bench});
	IFMCleanData = naomi.make.cleanIFM(bench, IFMData);
	if config.autoConfig
		bench.IFMData = IFMData;
		bench.IFMCleanData = IFMCleanData;
		bench.ZtCData = naomi.make.ZtC(bench);
	end
end