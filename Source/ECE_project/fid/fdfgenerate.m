function fdfgenerate(filename, data, par, options)
% FDFGENERATE(DIRNAME, IMAGES, PAR, OPTIONS)
%
% Generate a series of FDF files in directory DIRNAME. IAMGES is the 
% complex image space of data acquired with parameter PAR. The output
% format is governed by the OPTIONS.
% Data order is np, nv, [nv2], [options.label]
%
%     options.type      0  magnitude
%                       1  real
%                       2  imaginary
%                       3  complex
%                       4  phase
%     options.format    0  float
%                       1  int16
%                       2  int32
%
% Display order is set according to input order.
% Indices into labels slice, coil, and echo are recorded in header.
%
% WARNING: Due to bugs in Varian software, only labels of slice, 
% image, echo and coil, in that order, are currently supported in VnmrJ.
%
% see also FDFWRITE, FDFOPTIONS

% Author: L. Martyn Klassen
% Copyright 2003 Robarts Research Institute
% This program is copyrighted worldwide by the Robarts Research
% Institute.  Any distribution, copying or redistribution is expressly
% forbidden.

% Check the number of arguments
error(nargchk(3,4,nargin));

% Check the options
if nargin < 4
   options = fdfoptions([], par);
else
   options = fdfoptions(options, par);
end

% Check existance of output directory
if ~exist(filename,'dir')
   if unix(['mkdir ' filename])
      error('FDF:fileIO', 'Unable to create %s', filename);
   end
end

% Copy the procpar into the output directory
unix(['cp ' par.path '/procpar ' filename '/procpar']);

% aipLoad uses procpar information
par.seqcon(2) = 'c';
writeprocpar(filename, par, true);

if par.nD == 2
   % VnmrJ convention is to have readout and 1st phase encode switched
   % Data ordering is switch here
   % Header construction must also be switched below
   data = permute(data, [2 1 3:ndims(data)]);
elseif par.nD == 3
   % VnmrJ convention reverses directions
   data(:,:,:,:) = data(end:-1:1,end:-1:1,end:-1:1,:);
end

switch options.type
   case 0
      data = abs(data);
   case 1
      data = real(data);
   case 2
      data = imag(data);
   case 3
      % Do nothing
   case 4
      data = angle(data);
   otherwise
      error('FDF:options', 'Unrecognized image type %d', options.type);
end

% Check that the data size agrees with the options
siz = size(data);
ncount = numel(options.count);
siz(end+1:par.nD+ncount) = 1;
count = siz(par.nD+1:end);
if ncount ~= numel(count) || any(options.count(:) ~= count(:))
   error('FDF:options', 'Options count does not agree with data');
end

for p = 1:prod(count)
   % Generate the appropriate name for the given index
   pidx = p-1;
   slice = 1;
   echo = 1;
   coil = 1;
   image    = 1;
   if par.nD == 3
      nextFile = [filename '/img_'];
   else
      nextFile = [filename '/'];
   end
   for i = 1:ncount
      idx = mod(pidx, count(i)) + 1;
      pidx = floor(pidx/count(i));
      nextFile = sprintf('%s%s%03d', nextFile, options.label{i}, idx);
      if strcmp(options.label(i), 'slice')
         slice = idx;
      end
      if strcmp(options.label(i), 'coil')
         coil = idx;
      end
      if strcmp(options.label(i), 'image')
         image = idx;
      end
      if strcmp(options.label(i), 'echo')
         echo = idx;
      end
   end
   nextFile = [nextFile '.fdf']; %#ok<AGROW>

   % Delete any pre-existing data files
   if exist(nextFile, 'file')
      unix(['rm -rf ' nextFile]);
   end
   
   if par.nD == 2
      imageData = data(:,:,p);
   else
      imageData = data(:,:,:,p);
   end

   fdfwrite(nextFile, ...
      createHeader(par, slice, image, echo, coil, p, options), ...
      imageData);
end

if par.nD == 3
   unix(['ln ' nextFile ' ' filename '/data.fdf']);
   %copyfile(nextFile, [filename '/data.fdf']);
end

return



% Create a FDF header
function header = createHeader(par, slice, image, echo, coil, display, options)

% Calculate the rank
header.rank = par.nD;
if header.rank ~= 2 && header.rank ~= 3
   error('FDF:invalidRank', 'Rank of %d is not recognized', header.rank);
end

% Calculate the matrix
if header.rank == 2
   header.spatial_rank = {'2dfov'};
   
   % VnmrJ convention to switch 1st phase encode and readout
   header.matrix = [par.nv par.np/2];
   header.location = [par.ppe par.pro par.pss(slice)];
   header.roi = [par.lpe par.lro par.thk/10];
   header.origin = [par.ppe-par.lpe/2 par.pro-par.lro/2];
   header.span = [par.lpe par.lro];
   header.abscissa = {'cm', 'cm'};   
else
   header.spatial_rank = {'3dfov'};

   header.matrix = [par.np/2 par.nv par.nv2];
   header.location = [par.pro par.ppe par.ppe2];
   header.roi = [par.lro par.lpe par.lpe2];
   header.origin = header.location - header.roi./2;
   header.span = [par.lro par.lpe par.lpe2];
   header.abscissa = {'cm', 'cm', 'cm'};   
end
header.ordinate = {'intensity'};
header.nucleus = {par.tn};
header.nucfreq = par.sfrq;

switch options.format
   case 1
      header.storage = {'integer'};
      header.bits = 16;
      header.datatype = {'int16'};
   case 2
      header.storage = {'integer'};
      header.bits = 32;
      header.datatype = {'int32'};
   case 0
      header.storage = {'float'};
      header.bits = 32;
      header.datatype = {'float32'};
   otherwise
      error('FDF:options','Unrecognized format option %d', options.format);
end

switch (options.type)
   case 0
      header.type = {'absval'};
   case 1
      header.type = {'real'};
   case 2
      header.type = {'imag'};
   case 3
      header.type = {'complex'};
   otherwise
      error('FDF:options','Unrecognized data type %d', options.type);
end

% Rotatematrix is the logical to magnetic rotation matrix
% orientation is the magnet to logical rotation, i.e. the transpose
header.orientation   = rotatematrix([par.psi par.phi par.theta]).';
if par.nD == 2
   % VnmrJ convention to switch readout and 1st phase encode
   header.orientation   = header.orientation([2 1 3],:);
   % Empiracally determined that 1st column and 1st row must be negated
   % Rational is unknown as Varian is unable to explain rotations
   header.orientation(:,1) = -header.orientation(:,1);
   header.orientation(1,:) = -header.orientation(1,:);
elseif par.nD == 3
   % VnmrJ convention to switch 1st and 2nd columns
   % Rational is unknown as Varian is unable to explain rotations
   header.orientation   = header.orientation(:,[2 1 3]);
end

header.slice_no      = slice;
header.slices        = par.ns;

header.echo_no       = echo;
header.echoes        = par.ne;

header.coil          = coil;
header.coils         = par.nrcvrs;

header.array_index   = image;
header.array_dim     = par.arraydim;

header.display_order = display-1;

return

