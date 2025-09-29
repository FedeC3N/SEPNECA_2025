%%%
% Check demographic differences for the selected sub-group
% 
% Created on 29/04/2025
% 
% @author: Fede
%%%

clear
clc
restoredefaultpath

% Add the path functions
addpath(fullfile('..','shared','init'))
addpath(fullfile('..','shared','io'))

% Load the configuration
config = init();

% Read the Excel file
dummy_filename = sprintf('%s/SEPNECA_data.xlsx',config.path.demographic);
excel = readcell(dummy_filename,'Sheet','all');
headers = excel(1,:);
data = excel(2:end,:);

% Get the included mask
field_index = strcmp('included',headers);
included_mask = logical(cell2mat(data(:,field_index)));
data = data(included_mask,:);

% Divide the information
field_index = strcmp('conversion',headers);
group = cell2mat(data(:,field_index));
field_index = strcmp('age',headers);
age = cell2mat( data(:,field_index) );
field_index = strcmp('sex',headers);
sex = data(:,field_index);

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
fprintf('%.2f +- %.2f - %.2f +- %.2f --- p = %.3f\n', ...
    mean(age(index_no_converters)),std(age(index_no_converters)),...
    mean(age(index_converters)),std(age(index_converters)),...
    p_age)
fprintf('%i (M)/%i (F) - %i (M)/%i (F) --- p = %.3f\n', ...
    sum(strcmp('male', sex(index_no_converters))), ...
    sum(strcmp('female', sex(index_no_converters))), ...
    sum(strcmp('male', sex(index_converters))), ...
    sum(strcmp('female', sex(index_converters))),...
    p_sex);
fprintf('\n\n')
