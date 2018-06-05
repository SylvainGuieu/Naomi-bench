function dmAngle(bench)
    global naomiGlobalBench
    if nargin<1; bench = naomiGlobalBench; end
    dmAngle = naomi.measure.dmAngle(bench);
    naomi.config.dmAngle(bench, dmAngle);
end