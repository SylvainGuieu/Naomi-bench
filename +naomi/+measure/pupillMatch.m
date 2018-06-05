function [xCenterVector, yCenterVector, tipVector, tiltVector, arcsecVector] = pupillMatch(bench, order, nStep, arcsecStep)
%PUPILLMATCH Summary of this function goes here
%   Detailed explanation goes here
if nargin<2; order = 'tip'; end
if nargin<3; nStep = 6; end 
if nargin<4; arcsecStep = 30; end 

 axis = bench.axisMotor(order);
 sign = bench.axisSign(order);
 
 arcsecVector  = zeros(nStep, 1);
 xCenterVector = zeros(nStep, 1);
 yCenterVector = zeros(nStep, 1);
 tipVector = zeros(nStep, 1);
 tiltVector = zeros(nStep, 1);
 
 movement = 0;
 for i=1:nStep
     arcsecVector(i) = movement;
     naomi.action.resetDm(bench);
     [~,~,dTip,dTilt] = naomi.measure.missalignment(bench);
     IFC = naomi.measure.IFC(bench);
     [xCenter,yCenter] = naomi.compute.IFCenter(IFC);
     naomi.action.resetDm(bench);
     xCenterVector(i) = xCenter;
     yCenterVector(i) = yCenter;
     tipVector(i) = dTip;
     tiltVector(i) = dTilt;
     bench.gimbal.moveByArcsec(axis, sign*arcsecStep);
     movement = movement + arcsecStep;
 end
 
 if bench.config.plotVerbose
     naomi.plot.figure('Pupill Match');
     plot(arcsecVector,xCenterVector, 'b-o');
     hold on
     plot(arcsecVector,yCenterVector, 'r-o');
     hold off
     legend('x', 'y');
     xlabel(sprintf('%s => motor %s displacemet (arcsec)', order, axis));
     ylabel('X/Y displacement (pixel)');
 end
     
    
 end
 

