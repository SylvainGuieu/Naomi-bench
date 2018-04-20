function [xi,yj,mask] = actuatorPosition()
% actPos  Compute the 2d indices of DM241 actuators
%
%   [xi,yj,mask] = actuatorPosition()
%
%   Compute the positions and the mask representing the 241
%   actuators of the DM241. Following the definition of X,Y,
%   actuator 1 is at {-3,-8}, actuator 2 is at {-2,-8},
%   actuator 121 is at {0,0}...
%   The unit is the actuator spacing (2.5mm).
%   
%   xi:  x-position of actuators [unit of actuator spacing]
%   yj:  y-postions of actuators [unit of actuator spacing]
%   m:   mask of 0/1 to convert vector to map

    % Compute mesh and mask
    [Y,X] = meshgrid(-8:1:8,-8:1:8);
    mask = (Y.^2+X.^2) < 8.75*8.75;
    
    % Return only actuator in mask
    xi = X(mask);
    yj = Y(mask);
end

