% getData.m
%
% Generates the .mat from a VnmrJ FID file
%
% Modified by James Rioux Jan.19 2015, based on code
% written by J. Barral, M. Etezadi-Amoli, E. Gudmundson, and N. Stikov, 2009
%  (c) Board of Trustees, Leland Stanford Junior University    

%clear all
%close all

T1path = '../';

% Where to save the .mat 
savename = [T1path 'data/' 'T1_fitdata'];

%addpath('~/Documents/MATLAB/fid');
filename = '/../../fsems_01.fid';
petable  = '/../../fse64_8_1';
[img,par] = open_ir_fsems(filename,petable);

extra.tVec = par.ti * 1000;
extra.T1Vec = 1:5000; % this range can be reduced if a priori information is available
data = img;

save(savename,'data','extra')
