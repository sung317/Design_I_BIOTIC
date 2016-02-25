function t2_mat2img(matfile,imgfile)
  load(matfile);
  ana = make_ana(ll_T2(:,:,:,1));
  save_untouch_nii(ana,imgfile);
end

