function saveExtention(data, fileName, extname, extver)
    % save an extention to a fits file
    % saveExtention(data, fileName, extname, extver)
    % 
    % - data is the image data
    % - fileName  file path (must exists) 
    % - extname the extention name 'EXTNAME' keyword 
    % - extver  the extention vertion 'EXTVER' keyword
    import matlab.io.*
    
    fitswrite(data,fileName,'WriteMode','append');
    fptr = fits.openFile(fileName,'READWRITE');
    fits.movAbsHDU(fptr,fits.getNumHDUs(fptr));
    fits.writeKey(fptr,'EXTNAME',extname,'Name of extension');
    fits.writeKey(fptr,'EXTVER',extver,'Version of extension');
    fits.closeFile(fptr);
end

