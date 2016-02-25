function res = ifftnc(x)
% res = ifftnc(x)
% orthonormal centered ifft
% Calls appropriate function based on array size

switch numel(size(x))
  case 2
    res = ifft2c(x);
  case 3
    res = ifft3c(x);
  case 4
    res = x;
    for n=1:size(x,4)
      res(:,:,:,n) = ifft3c(x(:,:,:,n));
    end
end

end

