function [participant_id,session_id,group,age,sex] = load_demographics(config)

% Read the demographic functions from Excel

% Read the Excel file
dummy_filename = sprintf('%s/SEPNECA_data.xlsx',config.path.demographic);
data = readcell(dummy_filename,'Sheet','to_use');

% Split header-data
headers = data(1,:);
data = data(2:end,:);

% Participant_id
column_of_interest = strcmp(headers,'participant_id');
participant_id = data(:,column_of_interest);
participant_id(cellfun(@isempty, participant_id)) = {NaN};

% session_id
column_of_interest = strcmp(headers,'session_id');
session_id = data(:,column_of_interest);
session_id(cellfun(@isempty, session_id)) = {NaN};

% clin_outcome
column_of_interest = strcmp(headers,'conversion');
group = data(:,column_of_interest);
group(cellfun(@isempty, group)) = {NaN};
group = cell2mat(group);

% age
column_of_interest = strcmp(headers,'age');
age = data(:,column_of_interest);
age(cellfun(@isempty, age)) = {NaN};
age = cell2mat(age);

% sex
column_of_interest = strcmp(headers,'sex');
sex = data(:,column_of_interest);
sex(cellfun(@isempty, sex)) = {NaN};

end

