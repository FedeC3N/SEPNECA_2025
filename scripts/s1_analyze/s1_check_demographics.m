clear
clc
restoredefaultpath

% Paths
config.path.demographic = '../../data/excel';

% Read the Excel file
dummy_filename = sprintf('%s/data_all.xlsx',config.path.demographic);
excel = readcell(dummy_filename,'Sheet','SPAIN','Range','A1:DM109');

% Select only the included ones
headers = excel(1,:);
excel = excel(2:end,:);
included_mask = logical(cell2mat(excel(:,6)));
excel = excel(included_mask,:);

% Divide the information
subjects = excel(:,1);
group = cell2mat(excel(:,4));
age = cell2mat( excel(:,7) );
sex = cell2mat( excel(:,8) );

% Check the age
[p_age, anova_tbl, anova_stats] = anova1(age,group,'off');
multcompare(anova_stats);

% Check the sex
[tbl_chi,stats_chi,p_sex] = crosstab(group,sex);

% Print values for the manuscripts
index_no_converters = group == 0;
index_converters = group == 1;
fprintf('No converters - Converters\n')
fprintf('%i - %i\n', sum(index_no_converters), sum(index_converters))
fprintf('%.2f +- %.2f - %.2f +- %.2f\n', mean(age(index_no_converters)),std(age(index_no_converters)),...
    mean(age(index_converters)),std(age(index_converters)))
fprintf('%i (M)/%i (F) - %i (M)/%i (F)\n', sum(sex(index_no_converters) == 1),sum(sex(index_no_converters) == 2),...
    sum(sex(index_converters) == 1),sum(sex(index_converters) == 2))
fprintf('\n\n')
