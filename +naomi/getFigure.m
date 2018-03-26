function  fig = getFigure(name)
% get an existing figure or create a new  one with the given name 
% 
    fig = findobj('type','figure','name',name);
    if isempty(fig); figure('name',name);
    else set(0, 'CurrentFigure', fig); end;

end
