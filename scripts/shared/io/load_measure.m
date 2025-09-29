function measure = load_measure(config,subjects)
% Load all the subjects PLV and save it in a matrix

% Create the matrix
measure = [];
measure.all = nan(7875,numel(subjects),numel(config.visits),numel(config.bands));
measure.converted = nan(7875,numel(subjects),numel(config.bands));

% For each subject, find and load the plv.
for isubject = 1 : numel(subjects)
    
    % Load the file
    current_file = sprintf('%s-%s.mat',subjects{isubject},config.measure);
    current_file = fullfile(config.path.(config.measure),current_file);
    current_measures = load(current_file);
    
    % Store
    measure.all(:,isubject,1,:) = current_measures.(strcat(config.measure,'_v1'));
    measure.all(:,isubject,2,:) = current_measures.(strcat(config.measure,'_v2'));
    measure.all(:,isubject,3,:) = current_measures.(strcat(config.measure,'_v3'));
    measure.all(:,isubject,4,:) = current_measures.(strcat(config.measure,'_v4'));
    
end

% There is a subject with very weird values, so correct them
bad_index = find(measure.all > 1);
measure.all(bad_index) = nan;

% Get the baseline measure and the last valid visit for each subject
measure.baseline = squeeze(measure.all(:,:,1,:));

% Find the last valid visit
dummy = measure.all(:,:,:,4);
dummy = ~isnan(dummy);
dummy = squeeze(sum(dummy,1));
dummy = dummy > 0;

% Get the last valid visit of each subject
for isubject = 1 : size(dummy,1)
    
    % Get the index and save the matrix
    last_index = find(dummy(isubject,:),1,'last');
    measure.converted(:,isubject,:) = measure.all(:,isubject,last_index,:);
    
end

% Get the ratio values
measure.ratio = measure.converted ./ measure.baseline;

end

