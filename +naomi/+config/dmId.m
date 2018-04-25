function success = dmId(bench,dmId)
% configure the dmId for the bench
% if not id is given, a pop-up will ask for it
previousId = bench.config.dmId;
success = 0;
if nargin<2
    bench.config.askDmId();
else
    bench.config.dmId = dmId;
end

% if the dm was started with an other DM id, we need to restar it 
if bench.has('dm')
   if ~strcmp(bench.dm.sSerialName, bench.config.dmId)
       bench.dm = [];
       bench.startDm();
   end
end
success = 1;

end

