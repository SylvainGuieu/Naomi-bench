function ZtCData = ZtC(bench, IFMData, ztcMode)
	% Compute the ZtC Matrix 
	% The only required parameter is bench all others are taken from 
	% measurement stored inside bench or inside config.  
	% the given IFMdata is preferably cleaned 
	if nargin<3; ztcMode = [];end % will use the bench default 
  [~,~,~,~,ZtCData,~] = naomi.make.commandMatrix(bench, IFMData, ztcMode);
end