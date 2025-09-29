function evolution_lme(config)
% Performs a Linear Mixed Model on the three groups and PLV through 4
% visits

% Load the data
[subjects,group,age,sex] = load_demographics(config);
plv_all = load_plv(config,subjects);

% Estimate for each band
p_all = nan(size(plv_all,1),numel(config.bands));
is_significant_mask = false(size(plv_all,1),numel(config.bands));
for iband = 1 : numel(config.bands)
    
    for ipair = 1 : size(plv_all,1)
        
        % Create a table for the RANOVA model
        evolution = squeeze(plv_all(ipair,:,:,iband));
        tbl_all = array2table(evolution, 'VariableNames', {'PLV_v1', 'PLV_v2', 'PLV_v3', 'PLV_v4'});
        tbl_all.Group = group;
        tbl_all.Age = age;
        
        % Define the model (Age as covariate)
        Time = [1 2 3 4];
        rm = fitrm(tbl_all, 'PLV_v1-PLV_v4 ~ Group + Age', 'WithinDesign', Time);
        
        % Apply the model
        ranova_result = ranova(rm, 'WithinModel', 'Time');
        
        % Save the results
        p_all(ipair, iband) = table2array(ranova_result(6,5));
        is_significant_mask(ipair, iband) = p_all(ipair,iband) < 0.05;
        
    end
    
end

% Control multiple comparisons
p_all_vector = p_all(:);
p_all_vector_sorted = sort(p_all_vector);
FDR_threshold = 0.2*(1:numel(p_all_vector_sorted))/numel(p_all_vector_sorted);
is_significant_corrected_mask = p_all_vector_sorted' < FDR_threshold;
is_significant_corrected_mask = reshape(is_significant_corrected_mask,size(p_all));


% Create the output
output = [];
output.p_all = p_all;
output.is_significant_mask = is_significant_mask;
output.is_significant_corrected_mask = is_significant_corrected_mask;

% Save
outfile = fullfile(config.path.stats,'ranova_stats.mat');
save(outfile,'-struct','output')

end

