T1path = '/zeeman/jamesr/matlab/mapping/';

% Where to save the .mat 
savename = [T1path 'data/' 'T1_data'];

file1 = 'P00000.7';
file2 = 'P00512.7';
file3 = 'P98816.7';
file4 = 'P99328.7';

filenames = {file1, file2, file3, file4};
Ddir  = cell(4,1);
Pfile = cell(4,1);

for n=1:4
  % Get the filenames for the P-file and DICOM directories
  if strfind(filenames{n}, 'recon_') == 1
    Ddir(n) = filenames{n};
    Pfile{n} = filenames{n}(7:end);
  else
    Ddir{n} = ['recon_', filenames{n}];
    Pfile{n} = filenames{n};
  end
end
clear filenames;

hdr1 = read_gehdr(Pfile{1});
hdr2 = read_gehdr(Pfile{2});
hdr3 = read_gehdr(Pfile{3});
hdr4 = read_gehdr(Pfile{4});

TIs = [hdr1.image.ti, hdr2.image.ti, hdr3.image.ti, hdr4.image.ti];
[TIs,TIorder] = sort(TIs/1e3);  % convert to ms
Ddir  = Ddir(TIorder);

strSlice = '169';

I1 = double(dicomread([Ddir{1},'/Sec_',strSlice,'.i']));
Q1 = double(dicomread([Ddir{1},'/Sec_',strSlice,'.q']));
C1 = complex(I1,Q1);

I2 = double(dicomread([Ddir{2},'/Sec_',strSlice,'.i']));
Q2 = double(dicomread([Ddir{2},'/Sec_',strSlice,'.q']));
C2 = complex(I2,Q2);

I3 = double(dicomread([Ddir{3},'/Sec_',strSlice,'.i']));
Q3 = double(dicomread([Ddir{3},'/Sec_',strSlice,'.q']));
C3 = complex(I3,Q3);

P4 = double(dicomread([Ddir{4},'/Sec_',strSlice,'.ph']))./100;
I4 = double(dicomread([Ddir{4},'/Sec_',strSlice,'.i']));
Q4 = double(dicomread([Ddir{4},'/Sec_',strSlice,'.q']));
C4 = complex(I4,Q4);

dims = [256,256,1,4];
img_all = complex(zeros(dims));
extra.tVec = TIs;

% Phase correct based on longest TI
img_all(:,:,1) = C1 .* exp(-1i * P4);
img_all(:,:,2) = C2 .* exp(-1i * P4);
img_all(:,:,3) = C3 .* exp(-1i * P4);
img_all(:,:,4) = C4 .* exp(-1i * P4);
        
data = img_all;
extra.T1Vec = 1:4000;

save(savename,'data','extra')