function [angleRad, xPos, yPos] = dmAngle(bench, varargin)
%DMANGLE Summary of this function goes here
%   Detailed explanation goes here
P         = naomi.parseParameters(varargin, {'actionerVector', 'amplitude', 'nPushPull'}, 'measure.dmAngle');
actioners = naomi.getParameter(bench, P, 'actionerVector', 'dmAngleActionerVector');

nActioners =  length(actioners);
nSubAperture = bench.nSubAperture;
%[i,j] = naomi.compute.actuatorPosition(bench.dmOrientation);
data = zeros(nActioners,2);

for iActioners=1:nActioners
    [~,IFData] = naomi.measure.IF(bench, actioners(iActioners), P);
    data(iActioners, 1) = ( IFData.profileFit.xCenter - nSubAperture/2) * bench.xPixelScale;
    data(iActioners, 2) = ( IFData.profileFit.yCenter - nSubAperture/2) * bench.yPixelScale;
end
p = polyfit( data(:,1), data(:,2),1);
angleRad = atan(p(1)); 
if bench.config.plotVerbose
    naomi.plot.figure('DM Angle');
    plot( data(:,1), data(:,2), 'b-o');
    hold on; 
    plot( data(:,1), p(1)*data(:,1)+p(2) , 'r-');
    %text( data(:,1), data(:,2), actioners); 
    hold off; 
    xlabel('X ')
    title(sprintf('DM angle %.3e rad  %.3f degree', angleRad, angleRad*180/pi));
end
xPos = data(:,1); 
yPos = data(:,2); 
end

