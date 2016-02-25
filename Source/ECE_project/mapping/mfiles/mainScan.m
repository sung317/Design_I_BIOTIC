% mainScan.m
%
% Loads .mat file from the directory 'data' in the T1path, 
% performs T1 mapping, and displays the results 
%
% written by J. Barral, M. Etezadi-Amoli, E. Gudmundson, and N. Stikov, 2009
%  (c) Board of Trustees, Leland Stanford Junior University

%clear all
%close all

T1path = '../';

%% Where to find the data
loadpath = [T1path 'data/'];

% datasetnb = 2; %3;
% 
% switch (datasetnb)
% 	case 1
% 		filename = 'MP2_FSE'; % complex fit
% 		method = 'RD-NLS'
% 	case 2
%         filename = 'MP2_FSE'; % magnitude fit
%         %filename = 'Aviv_SEIR'; % magnitude fit
% 		method = 'RD-NLS-PR'
% 	case 3
%         filename = 'MP2_FSE'; % magnitude fit
%         %filename = 'Bragi_T1'; % magnitude fit
% 		method = 'Biexp'
% end

filename = 'T1_fitdata'; % magnitude fit
method = 'RD-NLS-PR';

savepath = [T1path 'fitdata/'] 

loadStr = [loadpath filename]
saveStr = [savepath 'T1Fit_ir_fsems_020315']

%% Perform fit
T1ScanExperiment(loadStr, saveStr, method);

%% Display results
T1FitDisplayScan(loadStr, saveStr);
