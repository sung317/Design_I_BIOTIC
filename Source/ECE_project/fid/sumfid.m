% sumfid allows one to read in, perform complex sum and write Varian 4T FID data.
%
% [K, HDR, BLOCK_HDR, PAR] = SUMFID(FPATH_OUT,FPATH1, FPATH2, ...) reads k-space data 
% from each fid file in the FID directory FPATH list (FPATH1, FPATH2 ...).
% Output is written to FPATH_OUT.
% DC_CORRECT is true and parameter file of combined fid identicle to that of FPATH1.
% The main header is returned in HDR and the block headers are returned in BLOCK_HDR
% see also READFID, WRITEFID, READPROCPAR, WRITEPROCPAR

function [k, hdr, block_hdr, par] = sumfid(fpath_out, varargin)

if nargin < 1
   error('SUMFID requires output fid file name');
end

if nargin < 3
   error('SUMFID requires output fid file name and minimum of two input fid files.');
end

% Turn on DC correction by default
dc_correct = true;

% Prepare loop to read in varargin files
nfid = nargin - 1;
par = readprocpar(varargin{1});
for i=1:nfid,
  disp(sprintf('Processing Input FID File %s',varargin{i}));
  [k,hdr,block_hdr,par] = readfid(varargin{i},par,dc_correct);
  if (exist('ksum')),
    ksum = ksum + k;
  else,
    ksum = k;
  end
end

% Write out summed Fid
if(~strcmp(fpath_out(end-3:end),'.fid')),
  fpath_out = [fpath_out,'.fid'];
end
[success, message] = mkdir(fpath_out);
  
% Check for proper fpath to varargin{1}
fpath_in = varargin{1};
if(~strcmp(fpath_in(end-3:end),'.fid')),
  fpath_in = [fpath_in '.fid'];
end

if (success),
  writefid(fpath_out, ksum, par, hdr, block_hdr, true);
  copyfile([fpath_in '/procpar'],[fpath_out '/procpar']);
  copyfile([fpath_in '/log'],[fpath_out '/log']);
  copyfile([fpath_in '/text'],[fpath_out '/text']);
else,
  error(message);
end

