function fdfwrite(filename, header, data)
% FDFWRITE(FILENAME, HEADER, DATA)
%
% Write an FDF file called FILENAME with header information HEADER
% and image DATA.
%
% see also FDFGENERATE, FDFOPTIONS

% Author: L. Martyn Klassen
% Copyright 2006 Robarts Research Institute
% This program is copyrighted worldwide by the Robarts Research
% Institute.  Any distribution, copying or redistribution is expressly
% forbidden.

% Check the number of arguments
error(nargchk(3, 3, nargin));

% Create a temporary file
% h_file = tempname;
% while (exist(h_file, 'dir') || exist(h_file, 'file'))
%    h_file = tempname;
% end

% Open the file
fp = fopen(filename, 'w+','ieee-be');

% Magic number is fixed by Varian
fprintf(fp, '#!/usr/local/fdf/startup\n');

% Print the rank
% Note: Using type float because Varian does - this does not conform to documentation
fprintf(fp, 'float  rank = %d;\n', header.rank);

% Print the spatial_rank
fprintf(fp, 'char  *spatial_rank = "%s";\n', header.spatial_rank{1});

% Print the storage
fprintf(fp, 'char  *storage = "%s";\n', header.storage{1});

% Print the bits
% Note: Using type float because Varian does - this does not conform to documentation
fprintf(fp, 'float  bits = %d;\n', header.bits);

% Print the type
fprintf(fp, 'char  *type = "%s";\n', header.type{1});

% Print the matrix
% Note: Using type float because Varian does - this does not conform to documentation
fprintf(fp, 'float  matrix[] = {');
fprintf(fp, ' %d,', header.matrix);
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

% Print the abscissa
fprintf(fp, 'char  *abscissa[] = {');
for i=1:length(header.abscissa)
   fprintf(fp, ' "%s",', header.abscissa{i});
end
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

% Print the ordinate
fprintf(fp, 'char  *ordinate[]= { "%s" };\n', header.ordinate{1});

% Print the span 
fprintf(fp, 'float  span[] = {');
fprintf(fp, ' %0.6f,', header.span);
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

% Print the origin
fprintf(fp, 'float  origin[] = {');
fprintf(fp, ' %0.6f,', header.origin);
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

% Print the coil information
fprintf(fp, 'int     coils = %d;\n', header.coils);
fprintf(fp, 'int     coil = %d;\n', header.coil);

% Print the nucleus information
fprintf(fp, 'char  *nucleus[] = {');
for i=1:length(header.nucleus)
   fprintf(fp, ' "%s",', header.nucleus{i});
end
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

% Print the nucleus frequency
fprintf(fp, 'float  nucfreq[] = {');
fprintf(fp, ' %0.6f,', header.nucfreq);
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

% Print the location
fprintf(fp, 'float  location[] = {');
fprintf(fp, ' %0.6f,', header.location);
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

% Print the roi
fprintf(fp, 'float  roi[] = {');
fprintf(fp, ' %0.6f,', header.roi);
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

fprintf(fp, 'int    slice_no = %d;\n', header.slice_no);
fprintf(fp, 'int    slices = %d;\n', header.slices);
fprintf(fp, 'int    echo_no = %d;\n', header.echo_no);
fprintf(fp, 'int    echos = %d;\n', header.echoes);
fprintf(fp, 'int    array_index = %d;\n', header.array_index);
fprintf(fp, 'float  array_dim = %0.4f;\n', header.array_dim);
fprintf(fp, 'float  image = %0.4f;\n', 1.0);
fprintf(fp, 'int    display_order = %d;\n', header.display_order);

% Matlab always creates bigendian FDF files
fprintf(fp, 'int    bigendian = 1;\n');

% Print the orientation
fprintf(fp, 'float  orientation[] = {');
fprintf(fp, ' %0.6f,', header.orientation.');
fseek(fp, -1, 0);
fprintf(fp, ' };\n');

% *********************************************************************
% This Code block can be omitted if fdfgluer is used
% fdfgluer must perform these operations itself
% Correct function of fdfgluer has not been validated
% However the algorithm for the checksum is not documented
% therefore fdfgluer must be used.
% Output the checksum
fprintf(fp, 'int checksum = %d;\n', 0); %sum(cast(data, 'int32')));

% Align the position in the file correctly for the data size
pos = ftell(fp);
datasize = header.bits / 8;
shift = mod(pos, datasize);
if (shift == 0)
   shift = datasize - 1;
else
   shift = shift - 1;
end
for i=1:shift
   fprintf(fp, '\n');
end

% Insert the final zero character
fwrite(fp, 0, 'uchar');
% *********************************************************************

% % Create a temporary file for the data
% fclose(fp);
% d_file = tempname;
% while (exist(d_file, 'dir') || exist(d_file, 'file'))
%    d_file = tempname;
% end
%
% fp = fopen(d_file, 'w', 'ieee-be');
if ~isreal(data)
   pos = ftell(fp);
   fwrite(fp, real(data), header.datatype{1}, header.bits/8);
   fseek(fp, pos+header.bits/8, 'bof');
   fwrite(fp, imag(data), header.datatype{1}, header.bits/8);
else
   fwrite(fp, data, header.datatype{1});
end
fclose(fp);
%
% % Call fdfgluer to generate the final file
% err = unix(['/vnmr/bin/fdfgluer ' h_file ' ' d_file ' ' filename]);
% 
% % Clear out the temporary files
% unix(['rm -rf ' h_file]);
% unix(['rm -rf ' d_file]);
%
% if err
%    error('FDF:gluer', 'Unable to execute fdfgluer');
% end

return
