clear
clc
close all
restoredefaultpath

% Add the path functions
addpath(fullfile('..','shared','init'))
addpath(fullfile('..','shared','stats'))

% Load the configuration
config = init();

% PLV
config.groups_selected = [0 1];
config.measure = 'pow';
config.stats = 'measure_baseline_ttest';
feval(config.stats,config)


% Select the analysis
% CIPLV
% config.groups_selected = [0 1];
% config.bootstrap = 100;
% config.measure = 'ciplv';
% config.stats = 'measure_baseline_anovan';
% perform_analysis(config);









