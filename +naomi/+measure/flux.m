function flux = flux(bench)
  % measure the (max) flux receive by the wavefront sensor
  img = bench.wfs.getRawImage;
  flux = max(img(:));
end