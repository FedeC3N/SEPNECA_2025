function tbl_all = convert_2_table(plv,subjects,group,age)
% Convert the values to a table suitable for LME in MATLAB.
% Each row has to be one time point

is_first = true;

for isubject = 1 : numel(subjects)
    
    for ivisit = 1 : 4
        
        % Create the dummy table to add at the end
        current_table = [];
        current_table.Subject = nominal(isubject);
        current_table.Group = nominal(group(isubject));
        current_table.Age = age(isubject);
        current_table.Time = nominal(ivisit);
        current_table.PLV = plv(isubject,ivisit);
    
        % Add the table to the end
        if is_first
            
            tbl_all = struct2table(current_table);
            is_first = false;
            
        else
            
            current_table = struct2table(current_table);
            tbl_all = [tbl_all;current_table];
            
        end
        
    end
    
end


end

