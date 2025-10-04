function plot_ptau(config)

% Load the group data
[participant_id,session_id,group,age,sex] = load_demographics(config);

% Load the ptau data
ptau = load_ptau(config);

% Plot ptau181
figure
plot(group+1,ptau.ptau181,'*'), hold on
boxplot(ptau.ptau181,group)
xlim([0 3])
xticklabels({'No converter', 'Converter'})
title('Ptau 181')

figure
plot(group+1,log10(ptau.ptau181),'*'), hold on
boxplot(log10(ptau.ptau181),group)
xlim([0 3])
xticklabels({'No converter', 'Converter'})
title('log10(Ptau 181)')

% Plot ptau217
figure
plot(group+1,ptau.ptau217,'*'), hold on
boxplot(ptau.ptau217,group)
xlim([0 3])
xticklabels({'No converter', 'Converter'})
title('Ptau 217')

figure
plot(group+1,log10(ptau.ptau217),'*'), hold on
boxplot(log10(ptau.ptau217),group)
xlim([0 3])
xticklabels({'No converter', 'Converter'})
title('log10(Ptau 217)')

% Plot ptau231
figure
plot(group+1,ptau.ptau231,'*'), hold on
boxplot(ptau.ptau231,group)
xlim([0 3])
xticklabels({'No converter', 'Converter'})
title('Ptau 231')

figure
plot(group+1,log10(ptau.ptau231),'*'), hold on
boxplot(log10(ptau.ptau231),group)
xlim([0 3])
xticklabels({'No converter', 'Converter'})
title('log10(Ptau 231)')


end