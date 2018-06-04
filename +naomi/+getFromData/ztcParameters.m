function [mask, maskName,  nEigenValue, nZernike, zeroMean, ztcOrientation] = ztcParameters(data, maskUnit)
%ZTCPARAMETERSFROMDATA Summary of this function goes here
%   Detailed explanation goes here
if nargin<2; maskUnit='pixel';end
K = naomi.KEYS;
[mask, maskName] = naomi.getFromData.ztcMask(data, maskUnit);
nEigenValue = data.getKey(K.ZTCNEIG);
nZernike = data.getKey(K.ZTCNZERN);
zeroMean = data.getKey(K.ZTCZMEAN);
ztcOrientation = data.getKey(K.ZTCORIENT);
end

