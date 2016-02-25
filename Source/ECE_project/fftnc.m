function res = fftnc(x)
% res = fftnc(x)
% orthonormal centered fft
% Calls appropriate function based on array size

switch numel(size(x))
  case 2
    res = fft2c(x);
  case 3
    res = fft3c(x);
  case 4
    res = x;
    for n=1:size(x,4)
      res(:,:,:,n) = fft3c(x(:,:,:,n));
    end
end

end

