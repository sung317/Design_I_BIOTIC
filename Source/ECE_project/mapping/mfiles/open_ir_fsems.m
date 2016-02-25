function [img,par] = open_ir_fsems(path, petable_path)

par = readprocpar(path);
[kspace, hdr] = readfid(path, par, 0);
nx = par.np/2;
ny = par.nv;
etl = par.etl;
nseg = ny/etl;
nz = par.ns;
ni = par.arraydim;
kspace = reshape(kspace,nx,etl,nz,nseg,ni);
kspace = permute(kspace,[1,2,4,3,5]);
kspace = reshape(kspace,nx,ny,nz,ni);

% sort the file according to the PE table
petable_file = fopen(petable_path,'r');
dummy = fgets(petable_file);  % read through 't1 ='
petable_y = fscanf(petable_file, '%d', [etl, nseg]);
petable_y = reshape(petable_y,ny,1) + ny/2;
fclose(petable_file);

data = zeros(nx,ny,nz,ni);
for c=1:ny
  data(:,petable_y(c),:,:) = kspace(:,c,:,:);
end

img = zeros(nx,ny,nz,ni);
for n=1:ni
  for m=1:nz
    img(:,:,m,n) = abs(ifft2c(squeeze(data(:,:,m,n))));   
  end
end

% Reorder interleaved slices
if nz>1
  [~,ind] = sort(par.pss);
  img(:,:,:,:) = img(:,:,ind,:);
end

return;