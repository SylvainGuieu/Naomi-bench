function hFig = findGui(name)
%FINDGUI find a gui by its name bring it ot front if found
%   return empty if not found
hFig = findall(groot, 'Type', 'figure', 'name', name');
if ~isempty(hFig)
    figure(hFig);
end
end

