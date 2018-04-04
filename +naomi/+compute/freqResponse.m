function FR = freqResponse(f,omega,amp,zeta)

% FR = freqResponse(f,omega,amp,zeta)
%
% Compute the Transfer Function of the sum 
% of several first order models, each defined
% by a central frequency, damping coefficient
% and amplitude:
%
%    s = 1.j * f / omega
%    TF(s) = amp / (s^2 + 2*zeta*s + 1)
%
% For the model to have a gain=1 at low frequencies,
% the sum of the amlitudes shall be unity.
%
% f:      frequencies for output array
% omega:  array of resonance frequencies (same unit as f)
% amp:    array of amplitude
% zero:   array of damping coefficient
%

No = length(omega);

FR = 0.j * f;
for o=1:No
   s = (0. + 1.j * f) / omega(o);
   FR = FR + amp(o) ./ (s.^2 + 2.*zeta(o)*s + 1);
end

end

