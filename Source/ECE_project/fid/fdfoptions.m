function options = fdfoptions(options, par)

% OPTIONS = FDDOPTIONS(OPTIONS)
%
% Checks validity and completeness of FDF options
%
% see also FDFGENERATE, FDFWRITE

% Author: L. Martyn Klassen
% Copyright 2006 Robarts Research Institute
% This program is copyrighted worldwide by the Robarts Research
% Institute.  Any distribution, copying or redistribution is expressly
% forbidden.

if nargin < 2
   error('FDF:options', 'Two input arguments required');
end

% Create the options structure
if isempty(options) || ~isstruct(options)
   options = struct('format', 0, 'type', 0);
end

% Check format 
if ~isfield(options, 'format') || isempty(options.format)
   options.format = 0;
end

% Check type
if ~isfield(options, 'type') || isempty(options.type)
   options.type = 0;
end

% Make sure options are not arrayed
options.type = options.type(1);
options.format = options.format(1);

% Check the options range
if options.type < 0 || options.type > 4
   error('FDF:options', 'Type option is not recognized');
end

if options.format < 0 || options.format > 3
   error('FDF:options', 'Format option is not recognized');
end

if ~isfield(options, 'count') || isempty(options.count)
   if par.nD == 2
      options.count = [getNumberSlices(par), getNumberImages(par), par.ne];
   else
      options.count = [getNumberImages(par), par.ne];
   end
end

if ~isfield(options, 'label') || isempty(options.label)
   if par.nD == 2
      options.label = {'slice', 'image', 'echo'};
   else
      options.label = {'vol', 'echo'};
   end
end
options.nlabel = length(options.label);

% Make sure label and count agree
if (options.nlabel ~= length(options.count))
   error('FDF:options', 'Labels and count differ in length');
end

return

% Get the number of images/volumes
function n = getNumberImages(par)
n = par.arraydim;
% Remove slices is pss is array for 2D images
if par.nD == 2
   for i=1:length(par.array)
      if any(strcmp('pss',par.array{i}))
         n = n / length(par.pss);
      end
   end
end

if par.seqcon(3) == 's'
   n = n / par.nv;
end
if par.seqcon(4) == 's'
   n = n / par.nv2;
end

% Add the receivers
n = n * par.nrcvrs;
return

% Return the number of slices (compressed or uncompressed)
function n = getNumberSlices(par)
n = length(par.pss);
return