function res = fft3c(x)
% res = fft3c(x)
% % orthonormal forward 3D FFT

res = 1/sqrt(length(x(:)))*fftshift(fftn(ifftshift(x)));

