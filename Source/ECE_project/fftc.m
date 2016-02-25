function res = fftc(x,dim)

% res = fftc(x, dim)
% orthonormal centered 1D FFT

res = 1/sqrt(squeeze(size(x,dim)))*fftshift(fft(ifftshift(x,dim),[],dim),dim);

