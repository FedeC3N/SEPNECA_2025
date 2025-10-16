function plot_significant_head(config)

% Load the data
config.stats = sprintf('%s_%s_%s_2_groups_stats.mat', config.measure,config.visit,config.stat_name);
[participant_id,session_id,group,age,sex] = load_demographics(config);
measure = load_measure(config,participant_id);

% Get the statistics
stats = load(fullfile(config.path.stats,config.stats));

% Decide what to plot
switch config.measure
    case 'plv'
        plot_plv(config,measure,stats,group)
    case 'pow'
        plot_pow(config,measure,stats,group)
    case 'strength'
        plot_strength(config,measure,stats,group)
end


end


function plot_plv(config,measure,stats,group)

for iband = 1 : numel(config.band_of_interest)

    current_band = config.band_of_interest(iband);

    % Get the band of interest
    p_of_interest = stats.p_original(:,current_band);
    tstat_of_interest = stats.tstat(:,current_band);

    % Get the significant links (applying correction if requested)
    significant_mask = get_significant_mask(config,p_of_interest);

    % Apply the sign
    significant_mask = significant_mask .* tstat_of_interest;

    % Create measure_all as the baseline + converted
    measure_all = measure.all(:,:,[1,4],current_band);

    % Create the output figure and save some colosr
    figure

    %%%%%%%%%%%%%%
    % Plot significant sensors in head
    % Converters > No Converters
    hold on
    colors = hex2rgb('#4C8505');
    % Plot the head with sensors empty
    [pos_elec, size_elec] = draw_head(config);

    % Convert significants to matrix again
    current_significant = significant_mask > 0;
    current_matrix = zeros(numel(size_elec)); % Matriz vacía
    current_matrix(triu(true(numel(size_elec)), 1)) = current_significant; % Rellenar la parte triangular superior
    current_matrix = current_matrix + current_matrix';

    % Find the sensors to plot
    to_plot_index = nansum(current_matrix,2) > 0;
    scatter(pos_elec(to_plot_index,1),pos_elec(to_plot_index,2),size_elec(to_plot_index),colors(1,:),'filled')

    % Plot lines between electrodes
    [to_plot_row,to_plot_col] = find(current_matrix > 0);

    for iplot = 1 : numel(to_plot_row)

        line([pos_elec(to_plot_row,1) pos_elec(to_plot_col,1)], [pos_elec(to_plot_row,2) pos_elec(to_plot_col,2)],...
            'Color',colors(1,:))

    end

    % Enhance the plot
    title(config.bands{current_band},'Interpreter','none')

    % Save the figure
    outnamename = sprintf('head_converter_greater_baseline_plv_%s.png',config.bands{current_band});
    outfile = fullfile(config.path.demographic,'for_python_plot',outnamename);
    saveas(gcf,outfile)

    % Converters < No Converters
    figure
    hold on
    % Plot the head with sensors empty
    [pos_elec, size_elec] = draw_head(config);

    % Convert significants to matrix again
    current_significant = significant_mask < 0;
    current_matrix = zeros(numel(size_elec)); % Matriz vacía
    current_matrix(triu(true(numel(size_elec)), 1)) = current_significant; % Rellenar la parte triangular superior
    current_matrix = current_matrix + current_matrix';

    % Find the sensors to plot
    to_plot_index = sum(current_matrix,2) > 0;
    scatter(pos_elec(to_plot_index,1),pos_elec(to_plot_index,2),size_elec(to_plot_index),colors(1,:),'filled')

    % Plot lines between electrodes
    [to_plot_row,to_plot_col] = find(current_matrix > 0);

    for iplot = 1 : numel(to_plot_row)

        line([pos_elec(to_plot_row,1) pos_elec(to_plot_col,1)], [pos_elec(to_plot_row,2) pos_elec(to_plot_col,2)],...
            'Color',colors(1,:))

    end

    % Enhance the plot
    title(config.bands{current_band},'Interpreter','none')

    % Save the figure
    outnamename = sprintf('head_converter_smaller_baseline_plv_%s.png',config.bands{current_band});
    outfile = fullfile(config.path.demographic,'for_python_plot',outnamename);
    saveas(gcf,outfile)


   


end




end

