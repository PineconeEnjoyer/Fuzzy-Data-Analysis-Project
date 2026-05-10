function [g] = g_measure_test(delta, p, matrix)
%funkcja do wyliczenia poziomu przypisania, binaryzacji i g-measure dla
%wybranej delty i p

y0 = zeros(size(matrix,1),1);    
    for i = 1:size(matrix,1)
        y0(i) = Rules(matrix(i,:), p);
    end
    binary_matrix = zeros(size(y0,1),1); 
    for j = 1:size(binary_matrix, 1)
        if y0(j) <= delta
            binary_matrix(j) = -1;
        else 
            binary_matrix(j) = 1;
        end
    end

    g = g_measure(binary_matrix, matrix(:,10));

end