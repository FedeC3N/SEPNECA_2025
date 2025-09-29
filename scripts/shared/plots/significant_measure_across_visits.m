function significant_measure_across_visits(config)

% Load the data 
config.stats = sprintf('%s_%s_ttest_2_groups_stats.mat', config.measure,config.visit);
[subjects,group,~,~] = load_demographics(config);
measure = load_measure(config,subjects);

% Select some colors
colors = [0    0.4470    0.7410;
    0.8500    0.3250    0.0980;
    0.9290    0.6940    0.1250];

% Load the mask of significant channels
stats = load(fullfile(config.path.stats,config.stats));

% Get the significant links (applying correction if requested)
significant_mask = get_significant_mask(config,stats);

% Create measure_all as the baseline + converted
measure_all = cat(4,measure.baseline, measure.converted);

figure('WindowState','maximize')

% Plot the average of each group for each band
for iband = 1 : numel(config.bands)
    
    % Get the current significant links
    current_significant = significant_mask(:,iband);
    
    for igroup = 0 : numel(unique(group)) - 1
        
        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(nanmean(measure_all(current_significant,group == igroup,iband,:),1),2));
        SE = squeeze(nanstd(nanmean(measure_all(current_significant,group == igroup,iband,:),1),[],2))/sqrt(sum(group == igroup));
        
        % Plot
        subplot(2,3,iband)
        hold on
        errorbar(mean_value,SE,'Color',colors(igroup + 1,:))
        xticks(1:2)
        xticklabels({'Baseline','t-conversion'})
        xlim([0 3])
        
        if isfield(config, 'y_limits')
            ylim(config.y_limits)
        end
        
    end
    legend({'No Converters', 'Converters'});
    title(config.bands{iband},'Interpreter','none')
    
    
    
end

% Save the figure
outfilename = sprintf('%s/%s.png',config.path.figures,config.stats(1:end-4));
saveas(gcf,outfilename)


end