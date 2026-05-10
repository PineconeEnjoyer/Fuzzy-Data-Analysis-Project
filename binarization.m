function [matrix, all_combinations] =  binarization(input_matrix,delta,p)
    %binaryzacja wyników dla wartości macierzy wejściowej w zależności od delta
    %tworzenie kombinacji delta-p
    matrix = zeros(size(input_matrix, 1), 25);
    all_combinations = zeros(2,25);
    ind = size(delta());
    ind = ind(end);
    
    number = 0;
    
    for delt = 1:ind
        
        for i = 1:size(input_matrix, 2)
            number = number + 1;
           col = input_matrix(:,i);
           for j = 1:size(input_matrix, 1)
               if col(j,1) <= delta(1,delt)
                   col(j,1) = -1;
               else 
                   col(j,1) = 1;
               end
           end
           matrix(:,number) = col; %przypisanie binarnego wyniku dla każdej kolumny
           %zmienna do wypisania wszyskich kombinacji p-delta
            %jest tak że [delta(1) p(1), delta(1) p(2) itd]
            %jako macierz 2 x 25
           all_combinations(1,number) = delta(1,delt);
           all_combinations(2,number) = p(1,i);
        end
    end
end