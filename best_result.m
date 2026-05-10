function [best_column_index,best_value] = best_result(matrix, expert_labels)
%wyliczenie 25 g-measure wartości i wybranie najlepszego z nich
    g_values = zeros(1,25);
    best_column_index=0;
    best_value = 0;
    for i = 1:size(matrix,2)
       g_values(i) = g_measure(matrix(:,i),expert_labels);
       if best_value < g_values(i)
           best_value = g_values(i);
           best_column_index = i;
       end
       %disp(g_values(i));
    end
end