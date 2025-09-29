function plot_ptau(config)

% Load the group data
[participant_id,session_id,clin_outcome,age,sex] = load_demographics(config);

% Load the ptau data
ptau = load_ptau(config);

% Filter the cases of interest
no_converter = clin_outcome == 0;
converter = clin_outcome == 2;
group = nan(numel(converter),1);
group(no_converter) = 1;
group(converter) = 2;

% Plot ptau181
figure
plot(group,ptau.ptau181,'*'), hold on
boxplot(ptau.ptau181,group)
xlim([0 3])
xticklabels({'No converter', 'Converter'})
title('Ptau 181')

% Plot ptau181
figure
plot(group,ptau.ptau231,'*'), hold on
boxplot(ptau.ptau231,group)
xlim([0 3])
xticklabels({'No converter', 'Converter'})
title('Ptau 231')


end