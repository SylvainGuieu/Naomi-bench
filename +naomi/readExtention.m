function data = readExtention(fileName, extname, extver)
%READEXTENTION(fileName, extname, extver) read image from a fits file extention
%   extention is iddentified by its extention name (EXTNAME keyword) and
%   the extention version (EXTVER)
% if extention is not found data output will be empty 
    import matlab.io.*
    fptr = fits.openFile(fileName,'READONLY');
    try
        fits.movNamHDU(fptr,'ANY_HDU',extname,extver);
        data = fits.readImg(fptr);
    catch ME
        data = [];
    end
    fits.closeFile(fptr);
end

