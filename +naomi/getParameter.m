function value = getParameter(bench, parameters, field, configField, default)
  %GETPARAMETER- return the value of one parameter taken from PARAMETERS or BENCH.config 
  %   look inside the parameters structure the requested field. If field is empty or do not 
  %   posses the field, look in the parameter the configField, if not found return the  one 
  %   found in bench.config as CONFIGFIELD is retuned 
  %   
  %   if not found an error is raised unless a default (which is returned) is provided 
  %  
  % Syntax:  value = getParameter(bench, parameter, field, configField)
  %          value = getParameter(bench, parameter, field, configField, 0.0)
  %
  % Inputs
  % ------
  %    bench: The naomi Baench object 
  %    parameters: structure as returned by parseParameters
  %    field: char the field name to be found in parameters
  %    configField: the field name to be found in bench.config if empty no search 
  %                 in config is done
  %    default: (optional) default value 
  %
  % Outputs
  % -------
  %    value: found value in ob or bench.config or default if provided 
              
  %    
  %
  % Example
  % -------
  %     function dmBias(bench, varargin)
  %        parameters = naomi.parseParameters(varargin, {'ztcMode', 'nStep', 'gain'}, dmBias);
  %        % if ztcMode is not found in parameters look at bench.config.dmBiasZtcMode default
  %        ztcMode = naomi.getParameter(bench, parameters, 'ztcMode', 'dmBiasZtcMode');
  %        nStep = naomi.getParameter(bench, parameters, 'nStep', 'dmBiasNstep');
  %        .....
  %     
  %     >>> dmBias(bench, 'nStep', 20);
  %     % OR
  %     >>> p =[]; p.nStep = 20;
  %     dmBias(bench, p)
  %     % OR 
  %     >>> p =[]; p.dmBiasNstep = 20; 
  %     >>> p.imfNloop = 2; % this has nothing to do with the function but can be use 
  %                     % in an other one as an 'observing block'
  %     >>> dmBias(bench, p);
  %
  % Author: Sylvain Guieu
  % May 2018; Last revision: 31-May-2018
  
  if isfield(parameters, field)
    value = parameters.(field);
    return;
  end
  
  if ~isempty(configField) && isfield(parameters, configField)
    value = parameters.(configField);
    return;
  end
  
  if ~isempty(bench)
       if ~isempty(configField)
          try
              value = bench.config.(configField);
              return 
          catch EM
              switch EM.identifier
                  case 'MATLAB:noSuchMethodOrField'
                  otherwise
                      rethrow(EM);
              end
          end
       end
  end
  
  if nargin<5
      error('Cannot find keyword parameter %s or %s', field, configField);
  else
      value = default;
  end
  
end