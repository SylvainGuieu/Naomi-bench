function afterAligment(bench)
%AFTERALIGMENT make the task necessary after the alignment of DM or DUMMY
%   If this is a Reference Mirror or a DUMMY :
%       - measure the pupillCenter 
%       - remove ramaining tiptilt (ask user)
%   If this is a DM
%       - measure the pupillCenter 
%       - measure the central actuator position 
%       - measure the pixel scale 
%       - remove ramaining tiptilt (ask user)
global naomiGlobalBench
if nargin<1; bench = naomiGlobalBench; end
[x,y] = naomi.measure.pupillCenter(bench);
naomi.config.pupillCenter(bench, x, y);
if ~bench.checkFlux()
    bench.log('WARNING not enough flux to measure pupill centering and pixel scale after alignment');
    return
end
if bench.isDm 
    if bench.has('dm')
        naomi.action.resetDm(bench); 


        %                                          |- no tip/tilt removal
        %                                          |  |- no phase ref
        %                                          |  |  |- no mask
        [~,phaseData] = naomi.measure.phase(bench, 0, 0, 0); 

        phaseData.setKey(naomi.KEYS.DPRTYPE, 'DM', naomi.KEYS.DPRTYPEc);

        [~,IFCData] = naomi.measure.IFC(bench);
        naomi.config.IFC(bench,IFCData);
        naomi.saveData(IFCData, bench);
        [xScale, yScale] = naomi.measure.pixelScale(bench);
        naomi.config.pixelScale(bench, xScale, yScale);
    end
else
    [~, phaseReferenceData] = naomi.measure.phaseReference(bench);
    naomi.config.phaseReference(bench,phaseReferenceData);
    naomi.saveData(phaseReferenceData, bench);
end
close all;
end

