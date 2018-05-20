function config = newConfig(updateLocal)
%NEWCONFIG create a new config object 
%   this is a naomi.Config which will be altered if by naomiLocalConfig if
%   it exists on the matlab path unless the first argument is false
    
    if nargin<1; updateLocal = 1; end
    config = naomi.Config();
    
    if updateLocal && exist('naomiLocalConfig', 'file')
        naomiLocalConfig(config);
    end
end

