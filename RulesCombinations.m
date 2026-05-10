function [y0_matrix] = RulesCombinations(matrix, p)
    %poziom przypisania w zależności od p
    y0_matrix = zeros(size(matrix, 1), 5);
    ind = size(p());
    ind = ind(end);
    
    for i = 1:ind
        y0 = zeros(size(matrix,1),1);
        for j = 1:size(matrix,1)
            p_v = p(:, i);
            y0(j) = Rules(matrix(j,:), p_v);
        end
        y0_matrix(:, i) = y0;
    end 
end
