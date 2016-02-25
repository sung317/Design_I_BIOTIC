clear all
close all

for dataset=7:8

saveStr = ['../fitdata/T1Fit_vary_nTIs_set' num2str(dataset)];

switch dataset

    case 1
        img_path = '~/Desktop/Scans/7T IRFSE Testing DY 021114/IRFSE_T1map_series_15mm_TR6_7/';
        img_names = {'IM-0005-0001.dcm','IM-0005-0002.dcm',...
                 'IM-0005-0003.dcm','IM-0005-0004.dcm',...
                 'IM-0005-0005.dcm','IM-0005-0006.dcm',...
                 'IM-0005-0007.dcm','IM-0005-0008.dcm',...
                 'IM-0005-0009.dcm','IM-0005-0010.dcm',...
                 'IM-0005-0011.dcm','IM-0005-0012.dcm',...
                 'IM-0005-0013.dcm'};
    case 2
        img_path = '~/Desktop/Scans/7T IRFSE Testing KB 041114/';
        img_names = {'IRFSE_T1map_series_15mm_TR6_7/IM-0005-0001.dcm','IRFSE_T1map_series_15mm_TR6_8/IM-0006-0001.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_7/IM-0005-0002.dcm','IRFSE_T1map_series_15mm_TR6_8/IM-0006-0002.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_7/IM-0005-0003.dcm','IRFSE_T1map_series_15mm_TR6_8/IM-0006-0003.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_7/IM-0005-0004.dcm','IRFSE_T1map_series_15mm_TR6_8/IM-0006-0004.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_7/IM-0005-0005.dcm','IRFSE_T1map_series_15mm_TR6_8/IM-0006-0005.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_7/IM-0005-0006.dcm','IRFSE_T1map_series_15mm_TR6_8/IM-0006-0006.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_7/IM-0005-0007.dcm'};
    case 3
        img_path = '~/Desktop/Scans/3T3 IRFSE MP2RAGE KB 071114/';
        img_names = {'IRFSE_T1map_series_4/IM-0002-0001.dcm','IRFSE_T1map_series_5/IM-0003-0001.dcm',...
                 'IRFSE_T1map_series_4/IM-0002-0002.dcm','IRFSE_T1map_series_5/IM-0003-0002.dcm',...
                 'IRFSE_T1map_series_4/IM-0002-0003.dcm','IRFSE_T1map_series_5/IM-0003-0003.dcm',...
                 'IRFSE_T1map_series_4/IM-0002-0004.dcm','IRFSE_T1map_series_5/IM-0003-0004.dcm',...
                 'IRFSE_T1map_series_4/IM-0002-0005.dcm','IRFSE_T1map_series_5/IM-0003-0005.dcm',...
                 'IRFSE_T1map_series_4/IM-0002-0006.dcm','IRFSE_T1map_series_5/IM-0003-0006.dcm',...
                 'IRFSE_T1map_series_4/IM-0002-0007.dcm'};
    case 4
        img_path = '~/Desktop/Scans/7T MP3RAGE MM 072814/IRFSE_T1map_series_15mm_TR6_6/';
        img_names = {'IM-0004-0001.dcm','IM-0004-0002.dcm',...
                 'IM-0004-0003.dcm','IM-0004-0004.dcm',...
                 'IM-0004-0005.dcm','IM-0004-0006.dcm',...
                 'IM-0004-0007.dcm','IM-0004-0008.dcm',...
                 'IM-0004-0009.dcm','IM-0004-0010.dcm',...
                 'IM-0004-0011.dcm','IM-0004-0012.dcm',...
                 'IM-0004-0013.dcm'};
    case 5
        img_path = '~/Desktop/Scans/7T IRFSE 3TI BS 080614/';
        img_names = {'IRFSE_T1map_series_15mm_TR6_8/IM-0006-0001.dcm','IRFSE_T1map_series_15mm_TR6_10/IM-0008-0001.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_9/IM-0007-0001.dcm','IRFSE_T1map_series_15mm_TR6_10/IM-0008-0002.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_9/IM-0007-0002.dcm','IRFSE_T1map_series_15mm_TR6_10/IM-0008-0003.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_9/IM-0007-0003.dcm','IRFSE_T1map_series_15mm_TR6_10/IM-0008-0004.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_9/IM-0007-0004.dcm','IRFSE_T1map_series_15mm_TR6_10/IM-0008-0005.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_9/IM-0007-0005.dcm','IRFSE_T1map_series_15mm_TR6_10/IM-0008-0006.dcm',...
                 'IRFSE_T1map_series_15mm_TR6_9/IM-0007-0006.dcm'};
    case 6
        img_path = '~/Desktop/Scans/3T3 IRFSE 3TI KW 080814/';
        img_names = {'IRFSE_T1map_series_6/IM-0004-0001.dcm','IRFSE_T1map_series_7/IM-0005-0001.dcm',...
                 'IRFSE_T1map_series_6/IM-0004-0002.dcm','IRFSE_T1map_series_7/IM-0005-0002.dcm',...
                 'IRFSE_T1map_series_6/IM-0004-0003.dcm','IRFSE_T1map_series_7/IM-0005-0003.dcm',...
                 'IRFSE_T1map_series_6/IM-0004-0004.dcm','IRFSE_T1map_series_7/IM-0005-0004.dcm',...
                 'IRFSE_T1map_series_6/IM-0004-0005.dcm','IRFSE_T1map_series_7/IM-0005-0005.dcm',...
                 'IRFSE_T1map_series_6/IM-0004-0006.dcm','IRFSE_T1map_series_7/IM-0005-0006.dcm',...
                 'IRFSE_T1map_series_6/IM-0004-0007.dcm'};
             
    case 7
        img_path = '~/Desktop/Scans/3T3 IRFSE 3TI BS 091614/';
        img_names = {'IRFSE_T1map_series_7/IM-0005-0001.dcm','IRFSE_T1map_series_8/IM-0006-0001.dcm',...
                     'IRFSE_T1map_series_8/IM-0006-0002.dcm','IRFSE_T1map_series_7/IM-0005-0002.dcm',...
                     'IRFSE_T1map_series_8/IM-0006-0003.dcm','IRFSE_T1map_series_7/IM-0005-0003.dcm',...
                     'IRFSE_T1map_series_8/IM-0006-0004.dcm','IRFSE_T1map_series_7/IM-0005-0004.dcm',...
                     'IRFSE_T1map_series_8/IM-0006-0005.dcm','IRFSE_T1map_series_7/IM-0005-0005.dcm',...
                     'IRFSE_T1map_series_8/IM-0006-0006.dcm','IRFSE_T1map_series_7/IM-0005-0006.dcm'};
        
    case 8
        img_path = '~/Desktop/Scans/3T3 IRFSE 3TI MM 091614/';
        img_names = {'IRFSE_T1map_series_6/IM-0004-0001.dcm','IRFSE_T1map_series_7/IM-0005-0001.dcm',...
                     'IRFSE_T1map_series_6/IM-0004-0002.dcm','IRFSE_T1map_series_7/IM-0005-0002.dcm',...
                     'IRFSE_T1map_series_6/IM-0004-0003.dcm','IRFSE_T1map_series_7/IM-0005-0003.dcm',...
                     'IRFSE_T1map_series_6/IM-0004-0004.dcm','IRFSE_T1map_series_7/IM-0005-0004.dcm',...
                     'IRFSE_T1map_series_6/IM-0004-0005.dcm','IRFSE_T1map_series_7/IM-0005-0005.dcm',...
                     'IRFSE_T1map_series_6/IM-0004-0006.dcm','IRFSE_T1map_series_7/IM-0005-0006.dcm',...
                     'IRFSE_T1map_series_6/IM-0004-0007.dcm'};

end

nTIs = length(img_names);
dims = [256,256,nTIs];
tVec = zeros(nTIs,1);

data = zeros(dims);
for n=1:dims(3)
  dcm = dicomread([img_path,img_names{n}]);
  hdr = dicominfo([img_path,img_names{n}]);
  data(:,:,n) = double(rot90(dcm,3));
  tVec(n) = hdr.InversionTime;
end

[~,order] = sort(tVec);
tVec = tVec(order);
data = abs(data(:,:,order));

maskFactor = 0.03;
mask = zeros(dims(1:2));
maskThreshold = maskFactor*max(max(abs(data(:,:,end))));
mask(abs(data(:,:,end)) > maskThreshold) = 1;
maskInds = find(mask);
nVoxAll = length(maskInds);
numVoxelsPerUpdate = min(floor(nVoxAll/10),1000); 
nSteps = ceil(nVoxAll/numVoxelsPerUpdate); 

maskdata = zeros(nVoxAll,nTIs);
for ii = 1:nTIs
  tmpVol = data(:,:,ii);
  maskdata(:,ii) = tmpVol(maskInds)';
end

T1_all = zeros([dims(1:2) 4 nTIs-3]);
extra.T1Vec = 1:5000;

for firstTI = 1:dims(3)-3  % Need at least 4 points?

  range = firstTI:dims(3);
  fitdata = maskdata(:,range);
  extra.tVec = tVec(range);
  nlsS = getNLSStruct(extra,1);
						   
  ll_T1 = zeros(nVoxAll, 4);
  startTime = cputime;
  fprintf('Processing fits for minTI = %d ms.\n', extra.tVec(1));
  h = waitbar(0, sprintf('Processing %d voxels', nVoxAll)); 

  for ii = 1:nSteps
    curInd = (ii-1)*numVoxelsPerUpdate+1;
    endInd = min(curInd+numVoxelsPerUpdate,nVoxAll);
    for jj = curInd:endInd
      [T1Est, bMagEst, aMagEst, res] = rdNlsPr(fitdata(jj,:),nlsS);
      ll_T1(jj,:) = [T1Est, bMagEst, aMagEst, res];
    end
    waitbar(ii/nSteps, h, sprintf('Processing %d voxels, %g percent done...\n',nVoxAll,round(endInd/nVoxAll*100)));
  end
  
  clear jj T1Est bMagEst aMagEst res;
  close(h);
  timeTaken = round(cputime - startTime);
  fprintf('Processed %d voxels in %g seconds.\n',nVoxAll, timeTaken);

  im = zeros(size(mask));
  % Going back from a numVoxels x 4 array to nbrow x nbcol x nbslice
  for ii = 1:4
    im(maskInds) = ll_T1(:,ii);
    T1_all(:,:,ii,firstTI) = im;
  end
  
end

save(saveStr, 'T1_all', 'tVec');

end