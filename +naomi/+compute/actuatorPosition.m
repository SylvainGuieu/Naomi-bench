function [xi,yj,mask] = actuatorPosition(orientation)
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
    if nargin<1; orientation = 'xy'; end
    % the mesh grid for the DM is the inverse of what computed
    % for a zernike
    [Y,X] = naomi.compute.orientedMeshgrid(-8:1:8, orientation);
    mask = (Y.^2+X.^2) < 8.75*8.75;
    
    % Return only actuator in mask
    xi = X(mask);
    yj = Y(mask);
end

