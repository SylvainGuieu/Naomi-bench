global gimbal
global autocol
import matlab.io.*

c = naomi.Config();
c.gimbalNumber = 4; 
c.gimbalRampPoints = 20;
if isempty(gimbal)
    gimbal = naomi.newGimbal(c);
end
if isempty(autocol)
    autocol = naomi.newAutocol(c);
end

stepmovements = {'rx', 'ry', 'rxy'};
%stepmovements = {'rxy'};
%stepmovements = {};
hommingmovements = {'rx', 'ry'};
%hommingmovements = {'ry'};



mkdir(c.todayDirectory);


for i=1:length(stepmovements)
    m = stepmovements{i};
    name = datestr(now,'yyyy-mm-ddTHH-MM-SS');
    [rx,ry,alpha, beta, dalpha, dbeta] = naomi.motorRampStep(c, m);
    filename = fullfile(c.todayDirectory, strcat('GIMB_', name, '.fits'));
    fitswrite([rx,ry,alpha, beta, dalpha, dbeta],filename);
    fptr = fits.openFile(filename,'READWRITE');

    fits.writeKey(fptr,'FILENAME',name,'Original filename');
    fits.writeKey(fptr,'GNUM',c.gimbalNumber,'Gimbal Serial Number');
    fits.writeKey(fptr,'MOVEMENT',m,'Moved axis');
    fits.writeKey(fptr,'STEP',c.gimbalRampStep,'Ramp step in mm');
    fits.writeKey(fptr,'RXZERO',c.gimbalRxZero,'Zero position for rX axis');
    fits.writeKey(fptr,'RYZERO',c.gimbalRxZero,'Zero position for rY axis');
    fits.writeDate(fptr);
    fits.closeFile(fptr);
end;



for i=1:length(hommingmovements)
    m = hommingmovements{i};
    name = datestr(now,'yyyy-mm-ddTHH-MM-SS');
    [time,rx,ry,alpha, beta, dalpha, dbeta] = naomi.motorHomingTest(c, m);
    filename = fullfile(c.todayDirectory, strcat('GIMB_HOME_', name, '.fits'));
    fitswrite([time,rx,ry,alpha, beta, dalpha, dbeta],filename);
    fptr = fits.openFile(filename,'READWRITE');

    fits.writeKey(fptr,'FILENAME',name,'Original filename');
    fits.writeKey(fptr,'GNUM',c.gimbalNumber,'Gimbal Serial Number');
    fits.writeKey(fptr,'MOVEMENT',m,'Moved axis');
    fits.writeKey(fptr,'STEP',c.gimbalRampStep,'Ramp step in mm');
    fits.writeKey(fptr,'RXZERO',c.gimbalRxZero,'Zero position for rX axis');
    fits.writeKey(fptr,'RYZERO',c.gimbalRxZero,'Zero position for rY axis');
    fits.writeDate(fptr);
    fits.closeFile(fptr);
end;


