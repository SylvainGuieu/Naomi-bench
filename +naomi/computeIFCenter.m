function [xC,yC] = computeIFCenter(IF)
% ComputeIFCenter  Compute the barycenter of an Influence Function
%
%   [xC,yC] = ComputeIFCenter(IF)
%
%   The function computes the barycenter of the Influence Function,
%   thus the position of the actuator. Unit is [pix] with 0,0 in the
%   middle of the image. The functions deals with negative Influence
%   Functions (first take the abs value).
% 
%   IF:      input Influence Function (Nsub,Nsub)
%   xC,yC:   output barycenter [pix]
%

[Nsub,~] = size(IF);

% Clean the IF
IFc = abs(IF - median(IF(~isnan(IF))));
IFc(IFc<0.1*max(IFc(:))) = NaN;
IFc = IFc - min(IFc(~isnan(IFc)));

% Compute barycenter
[Y,X] = meshgrid(1:Nsub,1:Nsub);
C = naomi.nansum(IFc(:));
xC = naomi.nansum(IFc(:) .* X(:)) / C;
yC = naomi.nansum(IFc(:) .* Y(:)) / C;

end

