function measure = load_measure(config,participant_id)

% Decide what to load
switch config.measure
    case 'plv'
        measure = load_plv(config,participant_id);
    case 'pow'
        measure = load_pow(config,participant_id);
end


end


function measure = load_plv(config,participant_id)
% Load all the subjects PLV and save it in a matrix

% Create the matrix
measure = [];
measure.all = nan(7875,numel(participant_id),numel(config.visits),numel(config.bands));
measure.converted = nan(7875,numel(participant_id),numel(config.bands));

% For each subject, find and load the plv.
for isubject = 1 : numel(participant_id)

    % Load the file
    current_subject = participant_id{isubject};
    current_subject = current_subject(1:end-2);
    current_file = sprintf('%s-%s.mat',current_subject,config.measure);
    current_file = fullfile(config.path.(config.measure),current_file);
    current_measures = load(current_file);

    % Store
    measure.all(:,isubject,1,:) = current_measures.(strcat(config.measure,'_v1'));
    measure.all(:,isubject,2,:) = current_measures.(strcat(config.measure,'_v2'));
    measure.all(:,isubject,3,:) = current_measures.(strcat(config.measure,'_v3'));
    measure.all(:,isubject,4,:) = current_measures.(strcat(config.measure,'_v4'));

end

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


function measure = load_pow(config,participant_id)
% For each subject, find and load the pow.

measure = [];
measure.all = nan(126,172,numel(participant_id),numel(config.visits));
measure.converted = nan(126,172,numel(participant_id));

for isubject = 1 : numel(participant_id)

    % Load the file
    current_subject = participant_id{isubject};
    current_subject = current_subject(1:end-2);
    current_file = sprintf('%s-%s.mat',current_subject,config.measure);
    current_file = fullfile(config.path.(config.measure),current_file);
    current_measures = load(current_file);

    % Store
    if ~isempty(current_measures.('spectrum_norm_v1'))
        measure.all(:,:,isubject,1) = current_measures.('spectrum_norm_v1');
    end
    if ~isempty(current_measures.('spectrum_norm_v2'))
        measure.all(:,:,isubject,2) = current_measures.('spectrum_norm_v2');
    end
    if ~isempty(current_measures.('spectrum_norm_v3'))
        measure.all(:,:,isubject,3) = current_measures.('spectrum_norm_v3');
    end
    if ~isempty(current_measures.('spectrum_norm_v4'))
        measure.all(:,:,isubject,4) = current_measures.('spectrum_norm_v4');
    end


end

% Save the frequencies
measure.freqs = current_measures.freqs;

% Get the baseline measure and the last valid visit for each subject
measure.baseline = squeeze(measure.all(:,:,:,1));

% Find the last valid visit
dummy = squeeze(nanmean(nanmean(measure.all,1),2));
dummy = ~isnan(dummy);

% Get the last valid visit of each subject
for isubject = 1 : size(dummy,1)

    % Get the index and save the matrix
    last_index = find(dummy(isubject,:),1,'last');
    measure.converted(:,:,isubject) = measure.all(:,:,isubject,last_index);

end


end