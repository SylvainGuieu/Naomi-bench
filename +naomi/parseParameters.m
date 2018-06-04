function parameters = parseParameters(argin, keys, callerName)
  %FUNCTION_NAME - parse list of {key1,value1,key2,value2, ...}
  %  
  %   if a key in argin is not in the list of keys an error is raise saying:
  %      'FUNCNAME does not accept optional keyword KEY'
  %   if argin is a list of one element this should be a structure, returned as it is 
  %      not check will be done on the parameter structure.
  %   otherwise if the number of element in argin is not odd an error is raised 
  % Syntax:  parameters = parseParameters({key1,value1, ...}, {'key1','key2'...}, 'funcName')
  %
  % Inputs
  % ------
  %    argin: list of key/valu typicaly this is the varargin of a function.
  %           If the list has only one element this should be a structure containing parameters
  %    keys:  list of accepted keys
  %    callerName:  The name of the function that desire the keys for clear  error messages
  %
  % Outputs
  % -------
  %    parameters:  A structure with parametes.key1 = value1, parametes.key2 = value2
  %    
  %
  % Example
  % -------
  %    function dmBias(bench, varargin)
  %        parameters = naomi.parseParameters(varargin, {'ztcMode', 'nStep', 'gain'}, dmBias);
  %        % if ztcMode is not found in parameters look at bench.config.dmBiasZtcMode default
  %        ztcMode = naomi.getParameter(bench, parameters, 'ztcMode', 'dmBiasZtcMode');
  %        .....
  %     
  %     >>> dmBias(bench, 'nStep', 20);
  %     % OR
  %     >>> p =[]; p.nStep = 20;
  %     >>> dmBias(bench, p)
  %     % OR 
  %     >>> p =[]; p.dmBiasNstep = 20; 
  %     >>> p.imfNloop = 2; % this has nothing to do with the function but can be use 
  %                     % in an other one as an 'observing block'
  %     >>> dmBias(bench, p);
  %
  % Author: Sylvain Guieu
  % May 2018; Last revision: 31-May-2018
  n = length(argin);
  if n==0
    parameters = struct(); 
    return;
  end
  
  if n==1
    parameters = argin{1};
    if ~isstruct(parameters)
      error('%s expecting a structure or key,value pair of arguments', callerName);
    end
    return ;
  end 
  if mod(n,2)
      error('%s optional argument must comme with key/value pairs', callerName);
  end
  
  % check that their is no unwanted keys
  for iArgin=1:2:n
    if ~any(strcmp(keys, argin{iArgin}))
      error('%s does not accept optional keyword argument "%s"', callerName, argin{iArgin});
    end
  end
  
  %parameters = struct(argin{:}); % this does not work if a value is a cell
  parameters = [];
  for iArgin=1:2:n
      parameters.(argin{iArgin}) = argin{iArgin+1};
  end
end
  
  