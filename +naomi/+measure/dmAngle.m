function [angleRad] = dmAngle(bench, actioners)
%DMANGLE Summary of this function goes here
%   Detailed explanation goes here
nActioners =  length(actioners);
nSubAperture = bench.nSubAperture;
%[i,j] = naomi.compute.actuatorPosition(bench.dmOrientation);
data = zeros(nActioners,2);

for iActioners=1:nActioners
    [~,IFData] = naomi.measure.IF(bench, actioners(iActioners), 1, 0.3);
    data(iActioners, 1) = (nSubAperture/2 - IFData.profileFit.xCenter) * bench.xPixelScale;
    data(iActioners, 2) = (nSubAperture/2 - IFData.profileFit.yCenter) * bench.yPixelScale;
end
p = polyfit( data(:,1), data(:,2),1);
angleRad = p(1); 
if bench.config.plotVerbose
    naomi.plot.figure('DM Angle');
    plot( data(:,1), data(:,2), 'b-o');
    hold on; 
    plot( data(:,1), p(1)*data(:,1)+p(2) , 'r-');
    hold off; 
    title(sprintf('DM angle %.3e rad  %.3f degree', angleRad, angleRad*180/pi));
end
end

