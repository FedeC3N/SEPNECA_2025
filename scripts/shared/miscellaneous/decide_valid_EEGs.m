%%%
% Mark as invalid subjects with weird values or no EEG in visit 1.
% Mark as invalid subjects with no EEG recordings.
% 
% Created on 29/04/2025
% 
% @author: Fede
%%%

clear
clc
restoredefaultpath

% Add the path functions
addpath(fullfile('..','init'))
addpath(fullfile('..','io'))

% Load the configuration
config = init();
config.measure = 'plv';

% Load the data
% Read the Excel file
dummy_filename = sprintf('%s/SEPNECA_data.xlsx',config.path.demographic);
excel = readcell(dummy_filename,'Sheet','all');
excel = excel(2:end,:);
subjects = excel(:,1);

% For each subject, find and load the plv.
measure_all = nan(7875,numel(subjects),numel(config.visits),numel(config.bands));
for isubject = 1 : numel(subjects)
    
    % Load the file
    current_subject = subjects{isubject};
    current_subject = current_subject(1:5);
    current_file = sprintf('%s-%s.mat',current_subject,config.measure);
    current_file = fullfile(config.path.(config.measure),current_file);
    if ~exist(current_file)
        continue
    end
    current_measures = load(current_file);
    
    % Store
    measure_all(:,isubject,1,:) = current_measures.(strcat(config.measure,'_v1'));
    measure_all(:,isubject,2,:) = current_measures.(strcat(config.measure,'_v2'));
    measure_all(:,isubject,3,:) = current_measures.(strcat(config.measure,'_v3'));
    measure_all(:,isubject,4,:) = current_measures.(strcat(config.measure,'_v4'));
    
end

% Find weird values
weird_values_index = find(measure_all > 1);
measure_all(weird_values_index) = nan;

% Save the valid index to copy in the Excel file
valid_index = zeros(numel(subjects),1);

% Find bad visit 1
valid_visit_1 = measure_all(:,:,1,4);
valid_visit_1 = ~isnan(valid_visit_1);
valid_visit_1 = sum(valid_visit_1,1);
valid_visit_1 = valid_visit_1 > 0;

% Any visit valid
valid_all_visits = measure_all(:,:,2:end,4);
valid_all_visits = ~isnan(valid_all_visits);
valid_all_visits = sum(valid_all_visits,3);
valid_all_visits = sum(valid_all_visits,1);
valid_all_visits = valid_all_visits > 0;

% Valid index
valid_index = valid_visit_1 & valid_all_visits;
valid_index = int16(valid_index');

%%%%
% COPY valid_index TO THE EXCEL
