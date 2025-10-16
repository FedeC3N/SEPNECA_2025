function plot_significant_links(config)

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
    figure('WindowState','maximize')

    %%%%%%%%%%%%%%
    % Plot significant sensors in head
    % Converters > No Converters
    subplot(2,2,1)
    hold on
    colors = [1 0 0; 0 0 1];
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

    % Converters < No Converters
    subplot(2,2,3)
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
    scatter(pos_elec(to_plot_index,1),pos_elec(to_plot_index,2),size_elec(to_plot_index),colors(2,:),'filled')

    % Plot lines between electrodes
    [to_plot_row,to_plot_col] = find(current_matrix > 0);

    for iplot = 1 : numel(to_plot_row)

        line([pos_elec(to_plot_row,1) pos_elec(to_plot_col,1)], [pos_elec(to_plot_row,2) pos_elec(to_plot_col,2)],...
            'Color',colors(2,:))

    end

    % Enhance the plot
    title(config.bands{current_band},'Interpreter','none')


    %%%%%%%%%%%%%%
    % Plot the evolution along visits
    % No converters > Converters
    colors = [0    0.4470    0.7410;
        0.8500    0.3250    0.0980;
        0.9290    0.6940    0.1250];
    current_significant = significant_mask > 0;
    for igroup = 0 : numel(unique(group)) - 1

        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(nanmean(measure_all(current_significant,group == igroup,:),1),2));
        SE = squeeze(nanstd(nanmean(measure_all(current_significant,group == igroup,:),1),[],2))/sqrt(sum(group == igroup));

        % Plot
        subplot(2,2,2)
        hold on
        errorbar(mean_value,SE,'Color',colors(igroup + 1,:))
        % xticks(1:4)
        % xlim([0 5])
        xticks(1:2)
        xlim([0 3])

        if isfield(config, 'y_limits')
            ylim(config.y_limits)
        end


    end
    if numel(unique(group)) == 2
        legend({'sMCI', 'Converters'});
    else
        legend({'sMCI', 'pMCI', 'Converters'});
    end
    title(config.bands{current_band},'Interpreter','none')

    % Export Excel results to plot in Python
    if sum(current_significant) > 0
        to_plot = squeeze(nanmean(measure_all(current_significant,:,:)));
        T = table( ...
            to_plot(:,1), ...
            to_plot(:,2), ...
            group, ...
            'VariableNames', {'Pre Conversion','Pos Conversion','Conversion'} );

        excelname = sprintf('converter_greater_ratio_plv_%s',config.bands{current_band});
        outexcel = fullfile(config.path.demographic,'for_python_plot',excelname);
        writetable(T, outexcel, 'FileType','spreadsheet', 'Sheet', 1);
    end

    % No converters < Converters
    current_significant = significant_mask < 0;
    for igroup = 0 : numel(unique(group)) - 1

        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(nanmean(measure_all(current_significant,group == igroup,:),1),2));
        SE = squeeze(nanstd(nanmean(measure_all(current_significant,group == igroup,:),1),[],2))/sqrt(sum(group == igroup));

        % Plot
        subplot(2,2,4)
        hold on
        errorbar(mean_value,SE,'Color',colors(igroup + 1,:))
        % xticks(1:4)
        % xlim([0 5])
        xticks(1:2)
        xlim([0 3])

        if isfield(config, 'y_limits')
            ylim(config.y_limits)
        end


    end
    if numel(unique(group)) == 2
        legend({'sMCI', 'Converters'});
    else
        legend({'sMCI', 'pMCI', 'Converters'});
    end
    title(config.bands{current_band},'Interpreter','none')

    % Export Excel results to plot in Python
    if sum(current_significant) > 0
        to_plot = squeeze(nanmean(measure_all(current_significant,:,:)));
        T = table( ...
            to_plot(:,1), ...
            to_plot(:,2), ...
            group, ...
            'VariableNames', {'Pre Conversion','Pos Conversion','Conversion'} );

        excelname = sprintf('converter_smaller_ratio_plv_%s',config.bands{current_band});
        outexcel = fullfile(config.path.demographic,'for_python_plot',excelname);
        writetable(T, outexcel, 'FileType','spreadsheet', 'Sheet', 1);
    end



end

% Save the figure
outfilename = sprintf('%s/%s.png',config.path.figures,config.stats(1:end-4));
saveas(gcf,outfilename)


end


function plot_pow(config,measure,stats,group)

for iband = 1 : numel(config.band_of_interest)

    current_band = config.band_of_interest(iband);

    % Get the band of interest
    p_of_interest = stats.p_original(:,current_band);
    tstat_of_interest = stats.tstat(:,current_band);
    p_of_interest = p_of_interest(config.occipital_channels);
    tstat_of_interest = tstat_of_interest(config.occipital_channels);

    % Get the significant links (applying correction if requested)
    significant_mask = get_significant_mask(config,p_of_interest);

    % Apply the sign
    significant_mask = significant_mask .* tstat_of_interest;

    % Create the output figure and save some colosr
    figure('WindowState','maximize')

    %%%%%%%%%%%%%%
    % Plot significant sensors in head
    % Converters > No Converters
    subplot(2,2,1)
    hold on
    colors = [1 0 0; 0 0 1];
    % Plot the head with sensors empty
    [pos_elec, size_elec] = draw_head(config);

    % Convert significants to matrix again
    current_significant = significant_mask > 0;

    % Find the sensors to plot
    to_plot_index = current_significant > 0;
    scatter(pos_elec(to_plot_index,1),pos_elec(to_plot_index,2),size_elec(to_plot_index),colors(1,:),'filled')
    title(config.bands{current_band},'Interpreter','none')

    % Converters < No converters
    subplot(2,2,3)
    hold on
    % Plot the head with sensors empty
    [pos_elec, size_elec] = draw_head(config);

    % Convert significants to matrix again
    current_significant = significant_mask < 0;

    % Find the sensors to plot
    to_plot_index = current_significant > 0;
    scatter(pos_elec(to_plot_index,1),pos_elec(to_plot_index,2),size_elec(to_plot_index),colors(2,:),'filled')
    title(config.bands{current_band},'Interpreter','none')

    %%%%%%%%%%%%%%
    % Plot the original power spectrum
    % Converters > No Converters
    colors = [0    0.4470    0.7410;
        0.8500    0.3250    0.0980;
        0.9290    0.6940    0.1250];
    current_significant = significant_mask > 0;
    for igroup = 0 : numel(unique(group)) - 1

        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(nanmean(measure.all(current_significant,:,group == igroup,1),1),3));

        % Plot
        subplot(2,2,2)
        hold on
        plot(measure.freqs,mean_value,'Color',colors(igroup + 1,:))

    end
    legend({'No Converters', 'Converters'});
    title(config.bands{current_band},'Interpreter','none')

    % Converters < No converters
    current_significant = significant_mask < 0;
    for igroup = 0 : numel(unique(group)) - 1

        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(nanmean(measure.all(current_significant,:,group == igroup,1),1),3));

        % Plot
        subplot(2,2,4)
        hold on
        plot(measure.freqs,mean_value,'Color',colors(igroup + 1,:))


    end
    legend({'No Converters', 'Converters'});
    title(config.bands{current_band},'Interpreter','none')



end

% Save the figure
outfilename = sprintf('%s/%s.png',config.path.figures,config.stats(1:end-4));
saveas(gcf,outfilename)


end


function plot_strength(config,measure,stats,group)

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
    measure_all = measure.all(:,:,:,current_band);

    % Create the output figure and save some colosr
    figure('WindowState','maximize')

    %%%%%%%%%%%%%%
    % Plot significant sensors in head
    % Converters > No Converters
    subplot(2,2,1)
    hold on
    colors = [1 0 0; 0 0 1];
    % Plot the head with sensors empty
    [pos_elec, size_elec] = draw_head(config);

    % Find the sensors to plot
    to_plot_index = significant_mask > 0;
    scatter(pos_elec(to_plot_index,1),pos_elec(to_plot_index,2),size_elec(to_plot_index),colors(1,:),'filled')

    % Enhance the plot
    title(config.bands{current_band},'Interpreter','none')

    % Converters < No Converters
    subplot(2,2,3)
    hold on
    % Plot the head with sensors empty
    [pos_elec, size_elec] = draw_head(config);

    % Find the sensors to plot
    to_plot_index = significant_mask < 0;
    scatter(pos_elec(to_plot_index,1),pos_elec(to_plot_index,2),size_elec(to_plot_index),colors(2,:),'filled')

    % Enhance the plot
    title(config.bands{current_band},'Interpreter','none')


    %%%%%%%%%%%%%%
    % Plot the evolution along visits
    % Converters > No Converters
    colors = [0    0.4470    0.7410;
        0.8500    0.3250    0.0980;
        0.9290    0.6940    0.1250];
    current_significant = significant_mask > 0;
    for igroup = 0 : numel(unique(group)) - 1

        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(nanmean(measure_all(current_significant,group == igroup,:),1),2));
        SE = squeeze(nanstd(nanmean(measure_all(current_significant,group == igroup,:),1),[],2))/sqrt(sum(group == igroup));

        % Plot
        subplot(2,2,2)
        hold on
        errorbar(mean_value,SE,'Color',colors(igroup + 1,:))
        xticks(1:4)
        xlim([0 5])

        if isfield(config, 'y_limits')
            ylim(config.y_limits)
        end


    end
    legend({'No Converters', 'Converters'});
    title(config.bands{current_band},'Interpreter','none')

    % Converters < No Converters
    current_significant = significant_mask < 0;
    for igroup = 0 : numel(unique(group)) - 1

        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(nanmean(measure_all(current_significant,group == igroup,:),1),2));
        SE = squeeze(nanstd(nanmean(measure_all(current_significant,group == igroup,:),1),[],2))/sqrt(sum(group == igroup));

        % Plot
        subplot(2,2,4)
        hold on
        errorbar(mean_value,SE,'Color',colors(igroup + 1,:))
        xticks(1:4)
        xlim([0 5])

        if isfield(config, 'y_limits')
            ylim(config.y_limits)
        end


    end
    legend({'No Converters', 'Converters'});
    title(config.bands{current_band},'Interpreter','none')


end

end
