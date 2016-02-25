fid = fopen('~/Desktop/S5_140325_T1_20_rt.txt');
nTIs = 20;
allstrs = textscan(fid,'%s');
nstrs = numel(allstrs{1});
start = nstrs - 2*nTIs;
time  = zeros(nTIs,1);
value = zeros(nTIs,1);
for t=1:nTIs
  time(t) = str2num(allstrs{1}{start+2*t-1});
  data(t) = str2num(allstrs{1}{start+2*t});
end
plot(time,abs(data));

extra.tVec = time;
extra.T1Vec = 1:1000;
nlsS = getNLSStruct(extra, 0, 0); 
[T1Est bMagEst aMagEst] = rdNlsPr(data,nlsS);
T1Est    