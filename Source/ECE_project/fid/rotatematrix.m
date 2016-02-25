function m = rotatematrix(angles)

% ROTATEMATRIX computes the rotation matrix used by Varian's VNMR software
% for the given Euler angles
%
%   M = ROTATEMATRIX(ANGLES) returns a 3x3 rotation matrix, M, given a 
%   the three Euler angles [PSI, PHI, THETA] in a 1x3 vector, ANGLES. The
%   units of ANGLES must be degrees. The rotation is from the logical to
%   the gradient reference frame


% Author: L. Martyn Klassen
% Copyright 2003 Robarts Research Institute
% This program is copyrighted worldwide by the Robarts Research
% Institute.  Any distribution, copying or redistribution is expressly
% forbidden.

% This is a totally weird convention, but comes directly from the
% VARIAN psg code and therefore does produce the correct results.

% Check that input is 3x1 or 1x3
if numel(angles) ~= 3
   error('ROTATEMATRIX requires 1x3 input vector');
end

% Compute the sine and cosine of the angles. Computation errors create
% small offsets from zero for sin(pi), cos(pi/2), etc., which must be
% removed prior to use.
angles = angles*pi/180;
sinv = sin(angles);
sinv(abs(sinv) < 4.*eps) = 0;

cosv = cos(angles);
cosv(abs(cosv) < 4.*eps) = 0;

m = zeros(3);

% NOTE: Varian defines the transpose of the below matrix, and then
% transposes it before use.
m(1,1) = sinv(2)*cosv(1) - cosv(2)*cosv(3)*sinv(1);
m(2,1) = -sinv(2)*sinv(1) - cosv(2)*cosv(3)*cosv(1);
m(3,1) = sinv(3)*cosv(2);

m(1,2) = -cosv(2)*cosv(1) - sinv(2)*cosv(3)*sinv(1);
m(2,2) = cosv(2)*sinv(1) - sinv(2)*cosv(3)*cosv(1);
m(3,2) = sinv(3)*sinv(2);

m(1,3) = sinv(1)*sinv(3);
m(2,3) = cosv(1)*sinv(3);
m(3,3) = cosv(3);
return
