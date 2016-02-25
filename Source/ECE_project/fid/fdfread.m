function [data, header] = fdfread(filename)
% [DATA, HEADER] = FDFREAD(FILENAME)
%
% Read an FDF file called FILENAME with header information HEADER
% and image DATA.
%
% see also FDFGENERATE, FDFOPTIONS, FDFWRITE

% Author: L. Martyn Klassen
% Copyright 2006 Robarts Research Institute
% This program is copyrighted worldwide by the Robarts Research
% Institute.  Any distribution, copying or redistribution is expressly
% forbidden.

% Check the number of arguments
error(nargchk(1, 1, nargin));

% Open the file
fp = fopen(filename, 'r','ieee-be');

if fp == -1
   error('Unable to open %s', filename);
end
   
% Skip the magic number line
fscanf(fp, '#!/usr/local/fdf/startup');
header = [];
res = true;

while res
   [res, header] = readheader(fp, header);
end

% Switch the endian if not bigendian
if isfield(header, 'bigendian')
   if ~header.bigendian
      pos = ftell(fp);
      fclose(fp);
      fp = fopen(filename, 'r', 'ieee-le');
      fseek(fp, pos, -1);
   end
end
if strcmp(header.storage, 'integer')
   datatype = sprintf('int%d', header.bits);
else
   datatype = sprintf('float%d', header.bits);
end
if strcmp(header.type, 'complex')
   pos = ftell(fp);
   data = fread(fp, Inf, datatype, 1);
   fseek(fp, pos+header.bits/8, -1);
   data = complex(data, fread(fp, Inf, datatype, 1));
else
   data = fread(fp, Inf, datatype);
end
fclose(fp);
data = reshape(data, header.matrix(:).');
header.datatype = {datatype};
return

function [res, header] = readheader(fp, header)
% Check for a null character which makers the end of the header
res = fread(fp, 1, 'uchar');
while all([105 99 102] ~= res)
   res = fread(fp, 1, 'uchar');
   if (res == 0)
      res = false;
      return
   end
end
fseek(fp, -1, 0);

% Read in the type of data
type = fscanf(fp, '%s', 1);
name = fscanf(fp, '%s', 1);
test = fscanf(fp, '%[^=]');

if any([test name] == '[')
   fscanf(fp, '%[^{]');
end
fscanf(fp, '%c', 1);
% Clear out any * [ ] =
name = name(name ~= '*');
name = name(name ~= '[');
name = name(name ~= ']');
name = name(name ~= '=');
name = name(name ~= '{');

if any(strcmp(type, {'float', 'int'}))
   header.(name) = fscanf(fp, '%e,');
elseif any(strcmp(type, {'char'}))
   fscanf(fp, '%[^"]');
   header.(name){1} = fscanf(fp, '"%[^"]"');
   if ~isempty(fscanf(fp, '%[,]'))
      fscanf(fp, '%[^"]');
      header.(name){end+1} = fscanf(fp, '"%[^"]"');
   end
end
% Get rid of any trailing brace
fscanf(fp, '%s;', 1);
res = true;
return
