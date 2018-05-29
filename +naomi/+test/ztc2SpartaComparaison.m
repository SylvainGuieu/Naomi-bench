function  ztc2SpartaComparaison(ZtCData)
%ZTC2SPARTACOMPARAISON Summary of this function goes here
%   Detailed explanation goes here
spt  = fitsread('E:\Config\Bench\RTC.M2DM.fits');
ZtC = ZtCData.data;
subplot(2,1,1);
plot(spt(:,1)); hold on ; plot(ZtC(2,':')); hold off
title(ZtCData.getKey(naomi.KEYS.ZTCORIENT, '?'));
subplot(2,1,2);
plot(spt(:,2)); hold on ; plot(ZtC(3,':')); hold off
end

