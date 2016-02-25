function [img,par] = open_mems(path)

par = readprocpar(path);
[k, ~, ~] = readfid(path);
k2 = reshape(k,[par.np/2,par.ne,par.ns,par.nv]);
dims = size(k2);
img = zeros(par.np/2,par.nv,par.ns,par.ne);
for n = 1:dims(2)
  for m=1:dims(3)
    img(:,:,m,n) = abs(ifft2c(squeeze(k2(:,n,m,:))));   
  end
end
% Reorder interleaved slices
if par.ns>1
  [~,ind] = sort(par.pss);
  img(:,:,:,:) = img(:,:,ind,:);
end
