function dmCenter(bench)
    global naomiGlobalBench
    if nargin<1; bench = naomiGlobalBench; end
    [~,IFCData] = naomi.measure.IFC(bench);
    naomi.config.IFC(bench,IFCData);
end