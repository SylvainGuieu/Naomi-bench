function [img, imgData] = image(bench)
  % measure a raw receive by the wavefront sensor
  img = bench.wfs.getRawImage;
  
  if nargout>1
      imgData = naomi.data.Image(img);
      bench.populateHeader(imgData);
  end
end