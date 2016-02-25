function t1_mat2img(matfile,imgfile)
  load(matfile);
  ana = make_ana(ll_T1(:,:,:,1));
  save_untouch_nii(ana,imgfile);
end

