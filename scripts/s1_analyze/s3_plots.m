clear
clc
close all
restoredefaultpath

% Add the path functions
addpath(fullfile('..','shared','init'))
addpath(fullfile('..','shared','io'))
addpath(fullfile('..','shared','miscellaneous'))
addpath(fullfile('..','shared','plots'))

% Load the configuration
config = init();
config.measure = 'pow';
config.visit = 'baseline';
config.stat_name = 'ttest';
config.band_of_interest = [1:6]; % {'delta'  'theta'  'alpha'  'low_beta'  'high_beta'  'gamma'}
config.p_threshold = 0.5;
config.correct= 'no'; % 'no', 'Bonferroni', 'BHFDR'
config.q = 0.2;

% Plot
config.plot = 'plot_significant_links';
feval(config.plot,config)

% config.plot = 'plot_ptau';
% feval(config.plot,config)

% config.plot = 'significant_measure_across_visits';
% feval(config.plot,config)
% 
% config.plot = 'plot_sig_links_sensors';
% feval(config.plot,config)

% config.plot = 'plot_measure_evolution';
% feval(config.plot,config)



