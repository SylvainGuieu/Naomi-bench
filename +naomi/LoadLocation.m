function  [locId,dirR,dirD,dirC,dirF] = LoadLocation(locId)
% LoadLocation   Define interactively the location (ESO/IPAG)
%
%   [locId,dirR,dirD,dirC,dirF] = LoadLocation()
%
%   locId:  'IPAG' or 'ESO-HQ'
%   dirR:   root directory
%   dirD:   directory for data         (dirR/Data)
%   dirC:   directory for config files (dirR/Config)
%   dirF:   directory for test figures (dirR/Figures)  

% Select location interactively if needed

if nargin < 1				     
    str = {'IPAG','ESO-HQ'};
    [locId,~] = listdlg('PromptString','Select a location:','SelectionMode','single','ListString',str);
    locId = char(str(locId));
end

% Define root path
if strcmp(locId,'IPAG') == 1
    dirR = 'N:\Bench\';
elseif strcmp(locId,'ESO-HQ') == 1
    dirR = 'C:\Users\NAOMI-IPAG-2\Documents\DM_Testing\';
else
    error('Location is not recognised');
end

% Set path variable
dirD = strcat(dirR,'\Data\');
dirC = strcat(dirR,'\Config\');
dirF = strcat(dirR,'\Figures\');

end

