function writeData(filename,Data,type,tpl,wfs, dm)
% WriteData  Write the data into FITS file with header
%
%   writeData(filename,Data,type,tpl,dm,wfs,src)
%   
%   The data are written as an image in the first HDU of
%   a FITS file named filename (this name shall not be
%   too long). Then the header is updated with as much
%   as possible information from WFS, DM and SRC. The 
%   following keys are also written:
%   DPR_TYPE = 'type'   (= ESO DPR TYPE)
%   PLT_NAME = 'plt'   (= ESO TPL NAME)
%
%   Float-type data are saved in single-precision in order
%   to be compatible with SPARTA. 
%
%   The HIERARCH keywords are unforunately prooly
%   supported by matlab so far.
%   
%   filename: name of FITS file, shall include the .fits
%   Data: input data (vector/matrix/array)
%   type: product type 'IFM_MATRIX', 'BIAS', 'PHASE'...
%   tpl: experiment name 'TEST', 'CALIB'...
%   wfs: WFS structure
%   dm: DM structure
%   

import matlab.io.*

% Some verbose
[pathstr,name,ext] = fileparts(filename);
fprintf('Write %s file:\n %s\n', type, filename);

% Write data into a new FITS file
% float data are stored as single precision
% for compatibility with SPARTA
if isfloat(Data)
    fitswrite(single(Data),filename);
else
    fitswrite(Data,filename);    
end

% Update HEADER
fptr = fits.openFile(filename,'READWRITE');
fits.writeKey(fptr,'FILENAME',name,'Original filename');
fits.writeKey(fptr,'MJD-OBS',juliandate(datetime('now'),'modifiedjuliandate'),'Modified Julian Date of writting header');
fits.writeKey(fptr,'SRC_ID',wfs.src,'Light Source identification');
if nargin>5
    fits.writeKey(fptr,'DM_NACT',dm.nAct,'Number of actuactor');
    fits.writeKey(fptr,'DM_ID',dm.sSerialName,'DM identification');
else
    fits.writeKey(fptr,'DM_NACT',0,'Number of actuactor');
    fits.writeKey(fptr,'DM_ID','DUMMY','DM identification');
end

fits.writeKey(fptr,'WFS_NSUB',wfs.Nsub,'Number of subapperture of WFS');
fits.writeKey(fptr,'WFS_NAME', wfs.model,'Model of WFS');

% fits.writeKey(fptr,'WFS_DIT',wfs.dit,'[us] WFS integration time');
% fits.writeKey(fptr,'WFS_TYPE',wfs.sReconstructor.type,'reconstructor type');

fits.writeKey(fptr,'ORIGIN','IPAG','NAOMI bench at IAPG');

fits.writeKey(fptr,'DPR_TYPE',type,'Type of product');
fits.writeKey(fptr,'TPL_NAME',tpl,'Name of test');
fits.writeKey(fptr,'TEMP0',naomi.GetTemp(0),'[degC] Temp. sensor');
fits.writeKey(fptr,'TEMP2',naomi.GetTemp(2),'[degC] Temp. sensor');
fits.writeDate(fptr);
fits.closeFile(fptr);

end

