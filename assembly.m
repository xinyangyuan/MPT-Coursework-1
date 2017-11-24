%{
    Full Assembly of Model Automatic Fittings
    %**********************************************************************
    Author: https://github.com/xinyangyuan
    %**********************************************************************

%}
clear
%--------------------------------------------------------------------------
% Load Raw Data
%--------------------------------------------------------------------------
load('rawData.mat')
stress = fs_s_535_1;
strain = e_535_1;

%--------------------------------------------------------------------------
% Fitting
%--------------------------------------------------------------------------
% Define the fitting class
fit = fitting(stress,strain);

% Set the scaling
%fit.scaleBool    = [0,0,0,0,0,0,0,0]; %turn off scales

% Set the boundary with manual input. class default is 'positive'
%fit.constriants = 'positive';
fit.constriants = 'manual'; 
fit.boundary = [1,5;1,5;1,200;1,200;1,200;500000,700000000;1,100;1,100];

% Set max number of evaluations/generations
fit.lamda = 500;
fit.g_max = 50;

% Run the fitting process
%fit.display = 1;
tic
fit.run() 
toc

% Obtain the best result
[w_best,best_fitness] = fit.result();
%fit.best
%fit.best_fitness
