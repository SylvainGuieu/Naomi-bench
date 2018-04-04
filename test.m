clear all;
global wfs_;
bench = naomi.objects.Bench();

naomi.startACE(bench.config);

% cFile = 'C:\Program Files (x86)\Imagine Optic\Configuration Files\HASO3_128_GE2_4651 Ebus.dat';
% wfs = naomi.objects.WfsHASO128();
% wfs.connect(cFile,'M660FA');
% wfs.Online();
bench.startWfs();

naomi.measure.phase(bench).plot;
naomi.action.alignManual(bench); 