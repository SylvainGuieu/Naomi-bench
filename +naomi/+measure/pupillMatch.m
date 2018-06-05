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
     
     f = naomi.compute.IFCenter(IFC);
     xCenter = f.xCenter;
     yCenter = f.yCenter;
     
     %[xCenter,yCenter] = naomi.compute.IFCenter(IFC);
     
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
     subplot(4,1,1);
     plot(arcsecVector,xCenterVector, 'b-o');
     xlabel(sprintf('%s => motor %s displacemet (arcsec)', order, axis));
     ylabel('X (pixel)');
     subplot(4,1,2);
     plot(arcsecVector,yCenterVector, 'r-o');
     xlabel(sprintf('%s => motor %s displacemet (arcsec)', order, axis));
     ylabel('Y  (pixel)');
     
     
     switch order
         case 'tip'
             v = tipVector;
         case 'tilt'
             v = tiltVector;
     end
     subplot(4,1,3);
     plot(v,xCenterVector,'b-o');
     xlabel(sprintf('%s um rms',order));
     ylabel('X (pixel)');
     subplot(4,1,4);
     plot(v, yCenterVector, 'r-o');
     xlabel(sprintf('%s um rms', order));
     ylabel('Y (pixel)');
 end
     
    
 end
 

