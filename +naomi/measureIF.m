function IF = measureIF(dm, wfs, act, Npp, Amp)
% getIF  Get the Influence Function of one actuator 
% 
%   IF = getIF(dm, wfs, act, Npp, Amp)
%
%   The requested actuator is push-pulled and the difference
%   is returned as its influence function.
% 
%   dm: input DM structure
%   wfs: input WFS structure
%   act: the requested actuator
%   Npp: number of push-pull
%   Amp: amplitude of the push-pull
% 
%   IF(Nsub,Nsub): the influence function of this actuator

    Nsub = wfs.Nsub;
    tppush = ones(Nsub,Nsub) * 0.0;
    tppull = ones(Nsub,Nsub) * 0.0;
    
    % Loop on N push-pull
    ref = dm.cmdVector(act);
    for pp=1:Npp
        dm.cmdVector(act) = ref + Amp;
        tppush = tppush + naomi.GetPhase(wfs,1);
        dm.cmdVector(act) = ref - Amp;
        tppull = tppull + naomi.GetPhase(wfs,1);
    end
    
    dm.cmdVector(act) = ref;  
    IF = (tppush - tppull) / (2*Amp*Npp);
    
    % Compute value of maximum
    Max = max(abs(IF(~isnan(IF))));
    
    % Plot 
    naomi.GetFigure('Influence Function');    
    clf; imagesc(IF); colorbar;
    xlabel('Y  =>'); ylabel('<=  X');
    title(sprintf('IF %i     max = %.2fum',act,Max));
end

