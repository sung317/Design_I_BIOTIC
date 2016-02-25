% getData.m
%
% Generates the .mat from the DICOM images. 
%
% Modified by James Rioux Aug.30 2013, based on code
% written by J. Barral, M. Etezadi-Amoli, E. Gudmundson, and N. Stikov, 2009
%  (c) Board of Trustees, Leland Stanford Junior University    

%clear all
%close all

T2path = '../';

% Where to save the .mat 
%savename = [T2path 'data/' 'MESE_Ag0_Ag05'];
savename = [T2path 'data/' 'SPIO'];

addpath('~/Desktop/EPIC/matlab/geX');

%filename = '~/Desktop/Scans/7T Magnelles 090613/P28672.7';
%filename = '~/Desktop/Scans/7T SPIO 100413/P34304.7';
%filename = '~/Desktop/Scans/7T SPIO 100413/P40448.7';
%filename = '~/Desktop/Scans/7T SPIO 102113/7T SPIO 102113 Pfiles/P80384.7';
%filename = '~/Desktop/Scans/7T SPIO 102113/7T SPIO 102113 Pfiles/P92672.7';
%filename = '~/Desktop/Scans/7T SPIO 102113/7T SPIO 102113 Pfiles/P00512.7';
filename = '~/Desktop/Scans/7T SPIO 102213/7T SPIO 102213 Pfiles/P13312.7';
%filename = '~/Desktop/Scans/7T SPIO 102413/7T SPIO 102413 Pfiles/P17920.7';
%filename = '~/Desktop/Scans/7T SPIO 102813a/7T SPIO 102813a Pfiles/P77824.7';
%filename = '~/Desktop/Scans/7T SPIO 102813b/7T SPIO 102813b Pfiles/P97792.7';
kspace_data = rawloadX(filename);
xsize_old = size(kspace_data,1);
ysize_old = size(kspace_data,2);
esize = size(kspace_data,3);

% Take first echo k-space data only, and zero-pad 2X
xsize_new = 2*xsize_old;
ysize_new = 2*ysize_old;
kspace_pad = zeros(xsize_new,ysize_new,esize);
kspace_pad((xsize_new-xsize_old)/2:(xsize_new-xsize_old)/2+xsize_old-1,(ysize_new-ysize_old)/2:(ysize_new-ysize_old)/2+ysize_old-1,:) = kspace_data(:,:,:,1,1);

img = zeros(size(kspace_pad));
for e=1:esize
  img(:,:,e) = fftshift(fft2(kspace_pad(:,:,e)));
end
img = abs(flipdim(img,2));

% Further zero-padding in image domain to restore square FOV
img_pad = zeros(xsize_new,xsize_new,esize);
img_pad(:,(xsize_new-ysize_new)/2:(xsize_new-ysize_new)/2+ysize_new-1,:) = img(:,:,:,1,1);

extra.tVec = (1:esize)*6.6;
extra.T2Vec = 1:500; % this range can be reduced if a priori information is available
data = img_pad;

save(savename,'data','extra')
