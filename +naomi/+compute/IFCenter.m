function [xC,yC] = IFCenter(IFArray)
% compute.IFCenter  Compute the barycenter of an Influence Function
%
%   [xC,yC] = compute.IFCenter(IFArray)
%
%   The function computes the barycenter of the Influence Function,
%   thus the position of the actuator. Unit is [pix] with 0,0 in the
%   middle of the image. The functions deals with negative Influence
%   Functions (first take the abs value).
% 
%   IFArray:      input Influence Function (nSub,nSub)
%   xC,yC:   output barycenter [pix]
%

[nSub,~] = size(IFArray);

% Clean the IF
IFcleanArray = abs(IFArray - median(IFArray(~isnan(IFArray))));
IFcleanArray(IFcleanArray<0.1*max(IFcleanArray(:))) = NaN;
IFcleanArray = IFcleanArray - min(IFcleanArray(~isnan(IFcleanArray)));

% Compute barycenter
[X,Y] = meshgrid(1:nSub,1:nSub);
C = naomi.compute.nansum(IFcleanArray(:));
xC = naomi.compute.nansum(IFcleanArray(:) .* X(:)) / C;
yC = naomi.compute.nansum(IFcleanArray(:) .* Y(:)) / C;

end

