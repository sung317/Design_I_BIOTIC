% Generate WM/GM masks
%fname1 = '~/Desktop/Scans/7T IRFSE Testing DY 021114/IRFSE_T1map_series_15mm_TR6_7/IM-0005-0009.dcm';
%fname1 = '~/Desktop/Scans/7T IRFSE Testing KB 041114/IRFSE_T1map_series_15mm_TR6_7/IM-0005-0005.dcm';
%fname1 = '~/Desktop/Scans/3T3 IRFSE MP2RAGE KB 071114/IRFSE_T1map_series_4/IM-0002-0005.dcm';
fname1 = '~/Desktop/Scans/7T MP3RAGE MM 072814/IRFSE_T1map_series_15mm_TR6_6/IM-0004-0009.dcm';
D1 = uint16(dicomread(fname1));

%fname2 = '~/Desktop/Scans/7T IRFSE Testing DY 021114/IRFSE_T1map_series_15mm_TR6_7/IM-0005-0010.dcm';
%fname2 = '~/Desktop/Scans/7T IRFSE Testing KB 041114/IRFSE_T1map_series_15mm_TR6_7/IM-0005-0006.dcm';
%fname2 = '~/Desktop/Scans/3T3 IRFSE MP2RAGE KB 071114/IRFSE_T1map_series_4/IM-0002-0006.dcm';
fname2 = '~/Desktop/Scans/7T MP3RAGE MM 072814/IRFSE_T1map_series_15mm_TR6_6/IM-0004-0010.dcm';
D2 = uint16(dicomread(fname2));

%fname3 = '~/Desktop/Scans/7T IRFSE Testing DY 021114/IRFSE_T1map_series_15mm_TR6_7/IM-0005-0012.dcm';
%fname3 = '~/Desktop/Scans/7T IRFSE Testing KB 041114/IRFSE_T1map_series_15mm_TR6_8/IM-0006-0006.dcm';
%fname3 = '~/Desktop/Scans/3T3 IRFSE MP2RAGE KB 071114/IRFSE_T1map_series_5/IM-0003-0005.dcm';
fname3 = '~/Desktop/Scans/7T MP3RAGE MM 072814/IRFSE_T1map_series_15mm_TR6_6/IM-0004-0012.dcm';
D3 = uint16(dicomread(fname3));

% WM/GM segmentation by arbitrary intensity thresholds
%wm_mask_rough = (D1<500) & (D2>300) & (D3>1500) & (D3<3000);
%gm_mask_rough = (D1<2000) & (D1>400) & (D2<400) & (D3>1500) & (D3<3000);
%wm_mask_rough = (D1<500) & (D2>300) & (D3>1000);
%gm_mask_rough = (D1<1500) & (D1>500) & (D2<1000) & (D3>1000);
%wm_mask_rough = (D1>150) & (D1<500) & (D2>300) & (D3>1000);
%gm_mask_rough = (D1<2000) & (D1>500) & (D2<2000) & (D3<1000);
wm_mask_rough = (D1<500) & (D2>250) & (D2<500) & (D3>800);
gm_mask_rough = (D1<1250) & (D1>600) & (D2<1000) & (D3>800) & (D3<1600);

%erode away outer edge of both masks
wm_mask_erode = imerode(wm_mask_rough,ones(2, 2));
gm_mask_erode = imerode(gm_mask_rough,ones(2, 2));

% Find connected white matter clusters
wm_mask_clust = zeros(size(wm_mask_erode));
wm_L = bwlabeln(wm_mask_erode);
wm_stats = regionprops(wm_L,'Area');
[~,wm_ind] = sort([wm_stats.Area],'descend');
% Keep only largest connected regions
for n=1:6
  wm_mask_clust(wm_L==wm_ind(n)) = 1;
end

% Find connected white matter clusters
gm_mask_clust = zeros(size(gm_mask_erode));
gm_L = bwlabeln(gm_mask_erode);
gm_stats = regionprops(gm_L,'Area');
[~,gm_ind] = sort([gm_stats.Area],'descend');
% Keep only largest connected regions
for n=1:10
  gm_mask_clust(gm_L==gm_ind(n)) = 1;
end

% figure('Position',[250 250 600 600],'Name','Threshold-Based Masks');
% subplot(2,2,1); imagesc(gm_mask_rough); title('GM Initial Rough');
% subplot(2,2,2); imagesc(gm_mask_clust); title('GM Eroded + Largest Clusters');
% subplot(2,2,3); imagesc(wm_mask_rough); title('WM Initial Rough');
% subplot(2,2,4); imagesc(wm_mask_clust); title('WM Eroded + Largest Clusters');

figure('Name','Select Seed Points, hit enter when done');
mask = zeros(size(D1));
D1_masked = D1;
while (1)
  D1_masked(mask==1) = max(D1(:));
  imagesc(D1_masked);
  [y,x] = ginput(1);
  if numel(x)==0
    break; 
  end
  %mask_new = segCroissRegion(200,D1,x,y);
  mask_new = regiongrowing(double(D1),ceil(x),ceil(y),200);
  mask = mask + mask_new;
  mask(mask>=1) = 1;
end

