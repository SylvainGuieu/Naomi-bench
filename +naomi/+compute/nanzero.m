function out = nanzero(input)
% out = nanzero(input)
%
%   Fill all NaN by 0.0

out = input;
out(isnan(out)) = 0;

end

