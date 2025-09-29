function neuro = load_neuro(config)
% Read the neuro data from Excel

% Read the Excel file
dummy_filename = sprintf('%s/data_all.xlsx',config.path.demographic);
excel = readcell(dummy_filename,'Sheet','all');
excel_headers = excel(1,:);
excel_data = excel(2:end,:);

% Select only the included
include_index = logical(cell2mat(excel_data(:,2)));
excel_data = excel_data(include_index,:);

% Divide the information
neuro = nan(size(excel_data,1),numel(config.neuro_names));

for ineuro = 1 : numel(config.neuro_names)
   
    neuro_index = find(ismember(excel_headers,config.neuro_names{ineuro}));
    
    % Before assigment, replace the missing values
    dummy = excel_data(:,neuro_index);
    missing_index = cellfun(@ismissing,dummy);
    dummy(missing_index) = {9999};
    dummy = cell2mat(dummy);
    neuro(:,ineuro) = dummy;
    
end

% Replace 9999 with nans
neuro(neuro == 9999) = nan;


end

