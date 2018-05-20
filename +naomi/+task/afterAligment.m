function success = afterAligment(bench)
%AFTERALIGMENT make the task necessary after the alignment of DM or DUMMY
%   If this is a DUMMY :
%       - measure the pupillCenter 
%       - remove ramaining tiptilt (ask user)
%   If this is a DM
%       - measure the pupillCenter 
%       - measure the central actuator position 
%       - measure the pixel scale 
%       - remove ramaining tiptilt (ask user)
success = 0;
[x,y] = naomi.measure.pupillCenter(bench);
naomi.config.pupillCenter(bench, x, y);
if ~strcmp(bench.config.dmId,  bench.config.DUMMY)
    [~,IFCData] = naomi.measure.IFC(bench);
    naomi.config.IFC(bench,IFCData);
    naomi.saveData(IFCData);
    [xScale, yScale] = naomi.measure.pixelScale(bench);
    naomi.config.pixelScale(bench, xScale, yScale);
end


end

