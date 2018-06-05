function pixelScale(bench)
    global naomiGlobalBench
    if nargin<1; bench = naomiGlobalBench; end
    [xScale, yScale] = naomi.measure.pixelScale(bench);
    naomi.config.pixelScale(bench, xScale, yScale);
end