function res = ifftc(x,dim)
%
% res = ifft2c(x,dim)
% orthonormal centered 1D ifft

res = sqrt(squeeze(size(x,dim)))*ifftshift(ifft(fftshift(x,dim),[],dim),dim);