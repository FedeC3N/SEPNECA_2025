function measure_converted_ttest(config)

fprintf(1,'Working on %s CONVERTED t-test.\n', config.measure)

% Add the paths
addpath(fullfile('..','shared','io'))

% Load the data
[participant_id,~,group,age,sex] = load_demographics(config);
measure = load_measure(config,participant_id);

% Decide what to estimate
switch config.measure
    case 'plv'
        plv_converted_ttest(config,measure,group);
    case 'pow'
        pow_converted_ttest(config,measure,group);
    case 'strength'
        strength_converted_ttest(config,measure,group);
end


end


function plv_converted_ttest(config,measure,group)

% Save space for the results
p_original = nan(size(measure.all,1),numel(config.bands));
tstat = nan(size(measure.all,1),numel(config.bands));

% Estimate the original p-values for each channel and band
fprintf(1,'   Estimate original p-values.\n')
for iband = 1 : numel(config.bands)

    for ipair = 1 : size(measure.all,1)

        % Create vectors for ANOVAN model
        measure_converted = measure.converted(ipair,:,iband)';

        [~,p,CI,stats] = ttest2(measure_converted(group==1),measure_converted(group==0));

        % Save the results
        p_original(ipair, iband) = p;
        tstat(ipair,iband) = stats.tstat;

    end

end

% Create the output
output = [];
output.test = sprintf('%s CONVERTED ttest', config.measure);
output.dimensions = 'links x bands';
output.p_original = p_original;
output.tstat = tstat;

% Save
outname = sprintf('%s_converted_ttest_%i_groups_stats.mat', config.measure, numel(config.groups_selected));
outfile = fullfile(config.path.stats,outname);
save(outfile,'-struct','output')

end


function pow_converted_ttest(config,measure,group)

% Save space for the results
p_original = nan(size(measure.all,1),numel(config.bands));
tstat = nan(size(measure.all,1),numel(config.bands));

% Estimate the original p-values for each channel and band
fprintf(1,'   Estimate original p-values.\n')
for iband = 1 : numel(config.bands)

    for isensor = 1 : size(measure.all,1)

        % Create vectors for ttest model
        freqs_index = measure.freqs > config.bands_freqs(iband,1) & ...
            measure.freqs < config.bands_freqs(iband,2);
        measure_converted = squeeze(sum(measure.converted(isensor,freqs_index,:),2));

        [~,p,CI,stats] = ttest2(measure_converted(group==1),measure_converted(group==0));

        % Save the results
        p_original(isensor, iband) = p;
        tstat(isensor,iband) = stats.tstat;

    end

end

% Create the output
output = [];
output.test = sprintf('%s CONVERTED ttest', config.measure);
output.dimensions = 'sensor x bands';
output.p_original = p_original;
output.tstat = tstat;

% Save
outname = sprintf('%s_converted_ttest_%i_groups_stats.mat', config.measure, numel(config.groups_selected));
outfile = fullfile(config.path.stats,outname);
save(outfile,'-struct','output')


end


function strength_converted_ttest(config,measure,group)

% Save space for the results
p_original = nan(size(measure.all,1),numel(config.bands));
tstat = nan(size(measure.all,1),numel(config.bands));

% Estimate the original p-values for each channel and band
fprintf(1,'   Estimate original p-values.\n')
for iband = 1 : numel(config.bands)

    for isensor = 1 : size(measure.all,1)

        % Create vectors for ANOVAN model
        measure_converted = measure.converted(isensor,:,iband)';

        [~,p,CI,stats] = ttest2(measure_converted(group==1),measure_converted(group==0));

        % Save the results
        p_original(isensor, iband) = p;
        tstat(isensor,iband) = stats.tstat;

    end

end

% Create the output
output = [];
output.test = sprintf('%s CONVERTED ttest', config.measure);
output.dimensions = 'links x bands';
output.p_original = p_original;
output.tstat = tstat;

% Save
outname = sprintf('%s_converted_ttest_%i_groups_stats.mat', config.measure, numel(config.groups_selected));
outfile = fullfile(config.path.stats,outname);
save(outfile,'-struct','output')


end
