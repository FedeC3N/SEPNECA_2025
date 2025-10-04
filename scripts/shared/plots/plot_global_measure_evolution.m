function plot_global_measure_evolution(config)

% Load the data
config.stats = sprintf('%s_%s_%s_2_groups_stats.mat', config.measure,config.visit,config.stat_name);
[participant_id,session_id,group,age,sex] = load_demographics(config);
measure = load_measure(config,participant_id);

% Extract the global measure depending on the dimension
switch config.measure
    case 'plv'
        plot_global_plv(config,measure,group)
    case 'pow'
        plot_global_pow(config,measure,group)
    case 'strength'
        plot_global_strength(config,measure,group)
end

end

function plot_global_plv(config,measure,group)

% Get the global measure (average along sensors)
global_measure = squeeze(nanmean(measure.all,1));

% Create the output figure and save some colosr
figure('WindowState','maximize')

for iband = 1 : numel(config.band_of_interest)

    current_band = config.band_of_interest(iband);

    %%%%%%%%%%%%%%
    % Plot the evolution along visits
    % No converters > Converters
    colors = [0    0.4470    0.7410;
        0.8500    0.3250    0.0980;
        0.9290    0.6940    0.1250];

    % Create the output figure and save some colosr
    
    for igroup = 0 : numel(unique(group)) - 1

        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(global_measure(group == igroup,:,current_band),1));
        SE = squeeze(nanstd(global_measure(group == igroup,:,current_band),[],1))/sqrt(sum(group == igroup));

        % Plot
        subplot(2,3,iband)
        hold on
        errorbar(mean_value,SE,'Color',colors(igroup + 1,:))
        xticks(1:4)
        xlim([0 5])

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
    sgtitle(config.measure)

    % Export Excel results to plot in Python
    T = table( ...
        global_measure(:,1,current_band), ...
        global_measure(:,2,current_band), ...
        global_measure(:,3,current_band), ...
        global_measure(:,4,current_band), ...
        group, ...
        'VariableNames', {'Visita 1','Visita 2','Visita 3','Visita 4','Conversion'} );

    excelname = sprintf('global_plv_%s',config.bands{current_band});
    outexcel = fullfile(config.path.demographic,'for_python_plot',excelname);
    writetable(T, outexcel, 'FileType','spreadsheet', 'Sheet', 1);


end

end


function plot_global_pow(config,measure,group)

% Create the output figure and save some colosr
figure('WindowState','maximize')

for iband = 1 : numel(config.band_of_interest)

    % Get the freq information
    current_band = config.band_of_interest(iband);
    freqs_index = measure.freqs > config.bands_freqs(current_band,1) & ...
            measure.freqs < config.bands_freqs(current_band,2);

    % Get the global measure (average along sensors)
    global_measure = squeeze(nanmean(nanmean(measure.all(config.occipital_channels,freqs_index,:,:),1),2));


    %%%%%%%%%%%%%%
    % Plot the evolution along visits
    % No converters > Converters
    colors = [0    0.4470    0.7410;
        0.8500    0.3250    0.0980;
        0.9290    0.6940    0.1250];

    % Create the output figure and save some colosr
    
    for igroup = 0 : numel(unique(group)) - 1

        % Get the mean value and SE to plot
        mean_value = squeeze(nanmean(global_measure(group == igroup,:),1));
        SE = squeeze(nanstd(global_measure(group == igroup,:),[],1))/sqrt(sum(group == igroup));

        % Plot
        subplot(2,3,iband)
        hold on
        errorbar(mean_value,SE,'Color',colors(igroup + 1,:))
        xticks(1:4)
        xlim([0 5])

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
    sgtitle(config.measure)

    % Export Excel results to plot in Python
    T = table( ...
        global_measure(:,1), ...
        global_measure(:,2), ...
        global_measure(:,3), ...
        global_measure(:,4), ...
        group, ...
        'VariableNames', {'Visita 1','Visita 2','Visita 3','Visita 4','Conversion'} );

    excelname = sprintf('global_pow_%s',config.bands{current_band});
    outexcel = fullfile(config.path.demographic,'for_python_plot',excelname);
    writetable(T, outexcel, 'FileType','spreadsheet', 'Sheet', 1);


end

end
