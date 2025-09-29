function measure_baseline_anovan(config)

fprintf(1,'Working on %s BASELINE ANOVAN.\n', config.measure)

% Add the paths
addpath(fullfile('..','shared','io'))

% Load the data
[subjects,group,age,sex] = load_demographics(config);
measure = load_measure(config,subjects);

% Save space for the results
p_original = nan(size(measure.all,1),numel(config.bands));

% Estimate the original p-values for each channel and band
fprintf(1,'   Estimate original p-values.\n')
for iband = 1 : numel(config.bands)
    
    for ipair = 1 : size(measure.all,1)
        
        % Create vectors for ANOVAN model
        measure_v1 = measure.baseline(ipair,:,iband)';
        
        [p, tbl, stats, terms] = anovan(measure_v1,{group,age},'continuous',[2],...
            'model','linear','varnames',{'Group','Age'},'display','off');
        
        % Save the results
        p_original(ipair, iband) = tbl{2,7};
        
    end
    
end

% Create the output
output = [];
output.test = sprintf('%s BASELINE ANOVA', config.measure);
output.dimensions = 'links x bands';
output.p_original = p_original;

% Save
outname = sprintf('%s_baseline_anovan_%i_groups_stats.mat', config.measure, numel(config.groups_selected));
outfile = fullfile(config.path.stats,outname);
save(outfile,'-struct','output')


end
