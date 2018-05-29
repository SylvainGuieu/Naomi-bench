function  actbug(bench, act, xCut)
%ACTBUG Summary of this function goes here
%   Detailed explanation goes here

if nargin<2; act = 117;end
if nargin<3;xCut = 40;end 
bench.dm.Reset;
ref = bench.wfs.haso.GetPhase();
pause(0.5);
bench.dm.cmdVector(act) = 0.3;
pause(0.5);
push = bench.wfs.haso.GetPhase()-ref;
bench.dm.cmdVector(act) = -0.3;
pause(0.5);
pull = bench.wfs.haso.GetPhase()-ref;
bench.dm.Reset;
pp = push-pull;

figure(11);
subplot(2,2,1); imagesc(push); colorbar;
hold on; plot([xCut, xCut], [0, 128], 'k-'); hold off;
subplot(2,2,2); imagesc(pull); colorbar;
subplot(2,2,3); imagesc(pp); colorbar;

figure(12);
subplot(3,1,1); plot(squeeze(push(:,xCut))); 
ylabel('push');
subplot(3,1,2); plot(squeeze(pull(:,xCut))); 
ylabel('pull');
subplot(3,1,3); plot(squeeze(pp(:,xCut))); 
ylabel('push-pull');
end

