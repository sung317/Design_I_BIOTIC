% mainScan_T2.m
%
% Loads .mat file from the directory 'data' in the T2path, 
% performs T2 mapping, and displays the results 
%
% modified by James Rioux, based on code
% written by J. Barral, M. Etezadi-Amoli, E. Gudmundson, and N. Stikov, 2009
%  (c) Board of Trustees, Leland Stanford Junior University

%clear all
%close all

T2path = '../';

%% Where to find the data
loadpath = [T2path 'data/'];

filename = 'T2_fitdata'; % magnitude fit

%% Where to save the data
savepath = [T2path 'fitdata/'] 

loadStr = [loadpath filename]
saveStr = [savepath 'T2Fit_020315']

%% Perform fit
T2ScanExperiment(loadStr, saveStr);

%% Display results
T2FitDisplayScan(loadStr, saveStr);
