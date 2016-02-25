function [idx, offset] = magframe(par,limitidx)

% [POS, OFFSET] = MAGFRAME(PAR, LIMITIDX)
%
% MAGFRAME returns the co-ordinates, POS, of each voxels in
% the magnet reference frame for the parameters PAR. Only
% LIMITIDX voxels are computed if it supplied. OFFSET of the 
% volume is provided for 3D volumes.


% Author: L. Martyn Klassen
% Copyright 2003 Robarts Research Institute
% This program is copyrighted worldwide by the Robarts Research
% Institute.  Any distribution, copying or redistribution is expressly
% forbidden.

if nargin > 1
   if islogical(limitidx)
      limitidx = find(limitidx);
   end
end

if par.nD == 3
	dimsize = [par.np/2 par.nv par.nv2];
	dimres = [par.lro par.lpe par.lpe2]./dimsize;
	dimoffset = [par.pro(1) par.ppe(1) par.ppe2(1)];
	rotmat = rotatematrix([par.psi(1) par.phi(1) par.theta(1)]);
	
	if nargin < 2
      limitidx = 1:prod(dimsize);
	end
	limitidx = limitidx(:)' - 1;
	idx = zeros(3, length(limitidx));
	
	dimshift = dimoffset - floor(dimsize./2) .* dimres;
	idx(1,:) = rem(limitidx, dimsize(1)) * dimres(1) + dimshift(1);
	idx(2,:) = rem(floor(limitidx./dimsize(1)), dimsize(2)) * dimres(2) + dimshift(2);
	idx(3,:) = rem(floor(limitidx./prod(dimsize(1:2))), dimsize(3)) * dimres(3) + dimshift(3);
	
	idx = rotmat*idx;
   offset = rotmat*dimoffset(:);
else
   x = (-par.np/4:par.np/4-1)./(par.np/2).*par.lro(1) + par.pro(1);
   y = (-par.nv/2:par.nv/2-1)./(par.nv).*par.lpe(1) + par.ppe(1);
   z = par.pss;
   par.ns = length(z);
   x = permute(x, [2 1]);
   x = x(:,ones(1,par.nv), ones(1,par.ns));
   y = y(ones(1,par.np/2),:,ones(1,par.ns));
   z = permute(z, [1 3 2]);
   z = z(ones(1,par.np/2),ones(1,par.nv),:);
   
   idx = [x(:) y(:) z(:)];
   idx = permute(idx, [2 1]);
   
	rotmat = rotatematrix([par.psi(1) par.phi(1) par.theta(1)]);
	
	if nargin > 1
      idx = idx(:,limitidx);
	end

	idx = rotmat*idx;
   offset = [];
end
return   