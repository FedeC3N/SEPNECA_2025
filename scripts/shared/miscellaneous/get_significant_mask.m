function significant_mask = get_significant_mask(config,p_all)

% Create the output
significant_mask = false(size(p_all));

% Apply correction, is requested
switch config.correct
    
    case 'no'
        
        % Just use the threshold
        significant_mask = p_all < config.p_threshold;
        
    case 'Bonferroni'
        
        % Get the number of comparisons performed
        num_tests = numel(p_all);
        new_threshold = config.p_threshold / num_tests;
        
        % Get the significance mask
        significant_mask = p_all < new_threshold;
        
    case 'BHFDR'
                    
            % Convert matrix to vector and sort it
            p_vector = p_all;
            m = numel(p_vector);
            [p_vector_sorted, sort_idx] = sort(p_vector);
            [~, unsort_idx] = sort(sort_idx);
            
            % Adjust itsex
            q_vector = config.q * (1:m)/m;
            q_vector = q_vector';
            index_significant = find(p_vector_sorted < q_vector,1,'last');
            
            % Get significant (corrected) values if any
            current_significant = false(size(p_vector_sorted));
            if numel(index_significant) > 0
                current_significant(1:index_significant) = true;
            end
            
            
            
            % Return to original order
            current_significant = current_significant(unsort_idx);
            significant_mask = current_significant;
            
        
end

end
