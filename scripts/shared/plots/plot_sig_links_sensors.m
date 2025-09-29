function plot_sig_links_sensors(config)

% Load the data 
config.stats = sprintf('%s_%s_ttest_2_groups_stats.mat', config.measure,config.visit);
[subjects,group,~,~] = load_demographics(config);
measure = load_measure(config,subjects);

% Load the mask of significant channels
stats = load(fullfile(config.path.stats,config.stats));

% Get the significant links (applying correction if requested)
significant_mask = get_significant_mask(config,stats);

% Create measure_all as the baseline + converted
measure_all = cat(4,measure.baseline, measure.converted);
if strcmp(config.visit,'baseline')
    visit = 1;
else
    visit = 2;
end

% Divide the plv matrix into groups
measure_group_0 = squeeze(nanmean(measure_all(:,group == 0,:,visit),2));
measure_group_1 = squeeze(nanmean(measure_all(:,group == 1,:,visit),2));
direction = sign(measure_group_1 - measure_group_0);
significant_mask = significant_mask .* direction;

% Plot the sensors with
directions = [-1 1];
colors = [0 0 1; 1 0 0];
legends = {'Converters < No Converters', 'Converters > No Converters'};
for idirection = 1 : numel(directions)
    
    figure('WindowState','maximize')
    
    for iband = 1 : numel(config.bands)
        
        subplot(2,3,iband)
        hold on
        
        % Plot the head with sensors empty
        [pos_elec, size_elec] = draw_head(config);
        
        % Convert significants to matrix again
        current_significant = significant_mask(:,iband);
        current_matrix = nan(numel(size_elec)); % Matriz vacía
        current_matrix(triu(true(numel(size_elec)), 1)) = current_significant; % Rellenar la parte triangular superior
        current_matrix = current_matrix == directions(idirection);
        current_matrix = current_matrix + current_matrix';
        
        % Find the sensors to plot
        to_plot_index = sum(current_matrix,2) > 0;
        scatter(pos_elec(to_plot_index,1),pos_elec(to_plot_index,2),size_elec(to_plot_index),colors(idirection,:),'filled')
        
        % Plot lines between electrodes
        [to_plot_row,to_plot_col] = find(current_matrix > 0);
        
        for iplot = 1 : numel(to_plot_row)
            
            line([pos_elec(to_plot_row,1) pos_elec(to_plot_col,1)], [pos_elec(to_plot_row,2) pos_elec(to_plot_col,2)],...
                'Color',colors(idirection,:))
            
        end
        
        % Enhance the plot
        title(config.bands{iband},'Interpreter','none')
        
    end
    
    % Save the figure
    outfilename = sprintf('%s/%s_direction_%i.png',config.path.figures,config.stats(1:end-4),...
        idirection);
    saveas(gcf,outfilename)
    
end






end