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
addpath(fullfile('..','shared','init'))
addpath(fullfile('..','shared','io'))

% Load the configuration
config = init();

% Load the data
% Read the Excel file
dummy_filename = '../../excel/SEPNECA_data.xlsx';
excel = readcell(dummy_filename,'Sheet','all');
headers = excel(1,:);
data_all = excel(2:end,:);
subjects = data_all(:,1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% PLV
config.measure = 'plv';

% For each subject, find and load the plv.
measure_all = nan(7875,numel(subjects),numel(config.visits),numel(config.bands));
for isubject = 1 : numel(subjects)
    
    % Load the file
    current_subject = subjects{isubject};
    current_subject = current_subject(1:5);
    current_file = sprintf('../../data/%s/%s-%s.mat',...
        config.measure, current_subject,config.measure);
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
plv_valid_index = zeros(numel(subjects),1);

% Find bad visit 1
dummy = nanmean(measure_all,4);
valid_visit_1 = dummy(:,:,1);
valid_visit_1 = nansum(valid_visit_1,1);
valid_visit_1 = valid_visit_1 > 0;

% Any visit valid
dummy = nanmean(measure_all,4);
valid_rest_visits = dummy(:,:,2:end);
valid_rest_visits = nansum(valid_rest_visits,3);
valid_rest_visits = nansum(valid_rest_visits,1);
valid_rest_visits = valid_rest_visits > 0;

% Valid index
plv_valid_index = valid_visit_1 & valid_rest_visits;
plv_valid_index = int16(plv_valid_index');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% POW
config.measure = 'pow';

% For each subject, find and load the plv.
measure_all = nan(126,172,numel(subjects),numel(config.visits));
for isubject = 1 : numel(subjects)
    
    % Load the file
    current_subject = subjects{isubject};
    current_subject = current_subject(1:5);
    current_file = sprintf('../../data/%s/%s-%s.mat',...
        config.measure, current_subject,config.measure);
    if ~exist(current_file)
        continue
    end
    current_measures = load(current_file);
    
    % Store
    if ~isempty(current_measures.('spectrum_norm_v1'))
        measure_all(:,:,isubject,1) = current_measures.('spectrum_norm_v1');
    end
    if ~isempty(current_measures.('spectrum_norm_v2'))
        measure_all(:,:,isubject,2) = current_measures.('spectrum_norm_v2');
    end
    if ~isempty(current_measures.('spectrum_norm_v3'))
        measure_all(:,:,isubject,3) = current_measures.('spectrum_norm_v3');
    end
    if ~isempty(current_measures.('spectrum_norm_v4'))
        measure_all(:,:,isubject,4) = current_measures.('spectrum_norm_v4');
    end
    

end

% Save the valid index to copy in the Excel file
pow_valid_index = zeros(numel(subjects),1);

% Find bad visit 1
dummy = measure_all(:,:,:,1);
valid_visit_1 = squeeze(nanmean(nanmean(dummy,1),2));
valid_visit_1 = valid_visit_1 > 0;

% Any visit valid
dummy = nanmean(measure_all(:,:,:,2:4),4);
valid_rest_visits = squeeze(nanmean(nanmean(dummy,1),2));
valid_rest_visits = valid_rest_visits > 0;

% Valid index
pow_valid_index = valid_visit_1 & valid_rest_visits;
pow_valid_index = int16(pow_valid_index);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% MANUALLY COPY THE VALID INDEX TO THE EXCEL