% getData.m
%
% Generates the .mat from a VnmrJ FID file
%
% Modified by James Rioux Jan.19 2015, based on code
% written by J. Barral, M. Etezadi-Amoli, E. Gudmundson, and N. Stikov, 2009
%  (c) Board of Trustees, Leland Stanford Junior University    

%clear all
%close all

T2path = '../';

% Where to save the .mat 
savename = [T2path 'data/' 'T2_fitdata'];

%addpath('/brml/home/kimb/vnmrsys/data/studies/');
filename = '../../mems_01.fid';
[img,par] = open_mems(filename);

extra.tVec = 1e3 * (par.te + (0:par.ne-1)*(par.esp));
extra.T2Vec = 10:1000; % this range can be reduced if a priori information is available
data = img;

save(savename,'data','extra')
