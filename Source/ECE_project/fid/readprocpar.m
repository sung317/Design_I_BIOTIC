function [par] = readprocpar(fpath)

% READPROCPAR reads in parameter used in FID acquisition
%
%   PAR = READPROCPAR(FPATH) reads the parameters in the the
%   procpar file in the FID directory FPATH
%
% see also WRITEPROCPAR, READFID, WRITEFID

if nargin < 1
   error('READPROCPAR requires one input argument.');
end

% Check for validity of file
fp = fopen([fpath '/procpar'], 'r');
if fp == -1
   fp = fopen([fpath '.fid/procpar'], 'r');
   if fp == -1
      fp = fopen([fpath '.par/procpar'], 'r');
      if fp == -1
         error(['READPROCPAR unable to open ' fpath ' for reading.']);
      else
         fpath = [fpath '.par'];
      end
   else
      fpath = [fpath '.fid'];
   end
end

% Initialize outputs
par.path   = fpath;
par.n_pars = 0;

buffer = fgets(fp);

% Parse the ASCII procpar file
while ( buffer ~= -1 )
      
      [name, buffer]  = strtok(buffer);  % First word is the parameter name
      [dummy, buffer] = strtok(buffer);  % Ignore second word
      [type, buffer]  = strtok(buffer);  % Third word is the variable type (1=real, 2=string)
            
      name = strrep(name, '$', '_');
      buffer = fgets(fp);
      if (type == '1')  % real
            val = sscanf(buffer, '%f');
            par.(name) = val(2:end).';
            buffer = fgets(fp);
      else % string
            n = sscanf(buffer, '%f', 1);
            if (n == 1)
               ind = findstr(buffer, '"');   % strip quotes around string

               par.(name) = buffer(ind(1)+1:ind(2)-1);
               buffer = fgets(fp);
            else
               for m = 1:n
                   ind = findstr(buffer, '"');   % strip quotes around string
                   par.(name){m} = buffer(ind(1)+1:ind(2)-1);
                   buffer = fgets(fp);
               end
            end
      end
      par.n_pars = par.n_pars + 1;
      buffer = fgets(fp);

end  % End of while loop

par.nrcvrs = sum(double(par.rcvrs) == 121);

array = par.array;
% Parse the data string to rebuild "array" into the
% format that Martyn's version was using.  Not sure
% how necessary this really is, but there it is.
index1 = 1;
index2 = 1;
incr = 0;
par.array = [];
par.array{1}{1} = [];
for o = 1:length(array)
   switch array(o)
   case '('
      incr = incr + 1;
      if incr > 1
         error('invalid coupling in array paramater.');
      end
   case ')'
      incr = incr - 1;
      if incr == 0
         index2 = 1;
      elseif incr < 0
         error('invalid coupling in array paramater.');
      end
   case ','
      if incr > 0
         index2 = index2 + 1;
      else
         index1 = index1 + 1;
      end
      par.array{index1}{index2} = [];
   otherwise
      par.array{index1}{index2} = [par.array{index1}{index2} array(o)];
   end
end

% Close file
fclose(fp);

return