function angles = rotateangles(M)

% ROTATEANGLES computes the Euler angles from a Varian rotation matrix
%
%   ANGLES = ROTATEMATRIX(M) returns a 1x3 vector, ANGLES, containing
%   [PSI PHI THETA] in degrees given a 3x3 rotation matrix, M. The
%   rotation is from the logical to the gradient reference frame.

% Author: L. Martyn Klassen
% Copyright 2003 Robarts Research Institute
% This program is copyrighted worldwide by the Robarts Research
% Institute.  Any distribution, copying or redistribution is expressly
% forbidden.

h = sqrt(M(3,1)*M(3,1) + M(3,2)*M(3,2));

if (h > 0) 
   phi = atan2(M(3,2),M(3,1));
   theta = atan2(h, M(3,3));
   psi = atan2(-M(2,1)*M(3,2)+M(2,2)*M(3,1), M(1,1)*M(3,2)-M(1,2)*M(3,1));
else
   phi = atan2(M(1,1), -M(1,2));
   theta = atan2(h, M(3,3));
   psi = 0;
end

angles = [psi phi theta] * 180/pi;
