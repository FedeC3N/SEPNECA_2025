function ptau = load_ptau(config)
% Read the demographic functions from Excel

% Read the Excel files
dummy_filename = sprintf('%s/SEPNECA_data.xlsx',config.path.demographic);
data = readcell(dummy_filename,'Sheet','to_use');

% Split header - data
headers = data(1,:);
data = data(2:end,:);

% ptau181
column_of_interest = strcmp(headers,'ptau181');
ptau181 = data(:,column_of_interest);
ptau181(cellfun(@ismissing, ptau181)) = {NaN};
ptau181 = cell2mat(ptau181);

% ptau231
column_of_interest = strcmp(headers,'ptau231');
ptau231 = data(:,column_of_interest);
ptau231(cellfun(@ismissing, ptau231)) = {NaN};
ptau231 = cell2mat(ptau231);

% Output
ptau = [];
ptau.ptau181 = ptau181;
ptau.ptau231 = ptau231;

end

