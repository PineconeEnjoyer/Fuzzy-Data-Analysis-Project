% FDA project
%by:
%Jagoda Więce
%Paulina Pękala

%Task2

clc
close all
clear all

data = readmatrix('FDA-data-e.xls');

matrix_membershipLevel = Task1;
matrix_ml_ex = [matrix_membershipLevel,data(:,4)];
p = [-0.5 -0.25 0 0.25 0.5];
delta = [-0.5 -0.25 0 0.25 0.5];
X = data(:,1:3);
%randomizacja danych
n = size(matrix_ml_ex, 1);            
idx1 = randperm(n);           
idx2 = randperm(n);  
idx3 = randperm(n);
idx4 = randperm(n);
idx5 = randperm(n);
%określenie wielkości macierzy treningowej
train_size = round(0.8 * n);
%podzielenie danych na trening i test  
train_data1 = matrix_ml_ex(idx1(1:train_size), :);      
test_data1  = matrix_ml_ex(idx1(train_size+1:end), :); 

train_data2 = matrix_ml_ex(idx2(1:train_size), :);     
test_data2  = matrix_ml_ex(idx2(train_size+1:end), :);  

train_data3 = matrix_ml_ex(idx3(1:train_size), :);     
test_data3 = matrix_ml_ex(idx3(train_size+1:end), :); 

train_data4 = matrix_ml_ex(idx4(1:train_size), :);     
test_data4  = matrix_ml_ex(idx4(train_size+1:end), :); 

train_data5 = matrix_ml_ex(idx5(1:train_size), :);     
test_data5  = matrix_ml_ex(idx5(train_size+1:end), :); 

%%
results = zeros(3,5); %zapisanie wyników g-measure, delta i p dla 5 danych testowych
% Data 1
y0_matrix_1 = RulesCombinations(train_data1,p); %wyliczenie poziomów przypisania dla każdego p
[binary_values1 , all_combinations_1] = binarization(y0_matrix_1,delta,p); %przypisywanie wartości 1 albo - 1 w zależności od delty, macierz kombinacji delty-p
[best_column_index_1,best_g_measure_1] = best_result(binary_values1,train_data1(:,10)); %wybranie kolumny z najlepszym g-measure w stosunku do eksperta, zwraza wartość g-measure oraz index kolumny w macierzy 144x25
best_combination_1 = all_combinations_1(:,best_column_index_1); %wybranie najlepszej kombinacji delta-p dla zwróconego indeksu
%wyświetlenie wyników
fprintf("1. For delta = %f and p = %f, G-measure is the best and is equal to: %.4f\n", ...
        best_combination_1(1,1), best_combination_1(2,1), best_g_measure_1);
best_g_test1 = g_measure_test(best_combination_1(1,1),best_combination_1(2,1),test_data1); %wyliczenie g-measure dla wybranego delta i p dla danych testowych
fprintf("the g-measure for test data is: %f",best_g_test1);
results(1,1) = best_g_test1; %g-measure
results(2,1) = best_combination_1(1,1); %delta
results(3,1) = best_combination_1(2,1); %p

% Data 2
y0_matrix_2 = RulesCombinations(train_data2,p);
[binary_values2 , all_combinations_2] = binarization(y0_matrix_2,delta,p);
[best_column_index_2,best_g_measure_2] = best_result(binary_values2,train_data2(:,10));
best_combination_2 = all_combinations_2(:,best_column_index_2);
fprintf("\n2. For delta = %f and p = %f, G-measure is the best and is equal to: %.4f\n", ...
        best_combination_2(1,1), best_combination_2(2,1), best_g_measure_2);
best_g_test2 = g_measure_test(best_combination_2(1,1),best_combination_2(2,1),test_data2);
fprintf("the g-measure for test data is: %f",best_g_test2);
results(1,2) = best_g_test2;
results(2,2) = best_combination_2(1,1);
results(3,2) = best_combination_2(2,1);

% Data 3
y0_matrix_3 = RulesCombinations(train_data3,p);
[binary_values3 , all_combinations_3] = binarization(y0_matrix_3,delta,p);
[best_column_index_3,best_g_measure_3] = best_result(binary_values3,train_data3(:,10));
best_combination_3 = all_combinations_3(:,best_column_index_3);
fprintf("\n3. For delta = %f and p = %f, G-measure is the best and is equal to: %.4f\n", ...
        best_combination_2(1,1), best_combination_2(2,1), best_g_measure_2);
best_g_test3 = g_measure_test(best_combination_3(1,1),best_combination_3(2,1),test_data3);
fprintf("the g-measure for test data is: %f",best_g_test3);
results(1,3) = best_g_test3;
results(2,3) = best_combination_3(1,1);
results(3,3) = best_combination_3(2,1);

% Data 4
y0_matrix_4 = RulesCombinations(train_data4,p);
[binary_values4 , all_combinations_4] = binarization(y0_matrix_4,delta,p);
[best_column_index_4,best_g_measure_4] = best_result(binary_values4,train_data4(:,10));
best_combination_4 = all_combinations_4(:,best_column_index_4);
fprintf("\n4. For delta = %f and p = %f, G-measure is the best and is equal to: %.4f\n", ...
        best_combination_4(1,1), best_combination_4(2,1), best_g_measure_4);
best_g_test4 = g_measure_test(best_combination_4(1,1),best_combination_4(2,1),test_data4);
fprintf("the g-measure for test data is: %f",best_g_test4);
results(1,4) = best_g_test4;
results(2,4) = best_combination_4(1,1);
results(3,4) = best_combination_4(2,1);

% Data 5
y0_matrix_5 = RulesCombinations(train_data5,p);
[binary_values5 , all_combinations_5] = binarization(y0_matrix_5,delta,p);
[best_column_index_5,best_g_measure_5] = best_result(binary_values5,train_data5(:,10));
best_combination_5 = all_combinations_5(:,best_column_index_5);
fprintf("\n5. For delta = %f and p = %f, G-measure is the best and is equal to: %.4f\n", ...
        best_combination_5(1,1), best_combination_5(2,1), best_g_measure_5);
best_g_test5 = g_measure_test(best_combination_5(1,1),best_combination_5(2,1),test_data5);
fprintf("the g-measure for test data is: %f\n",best_g_test5);
results(1,5) = best_g_test5;
results(2,5) = best_combination_5(1,1);
results(3,5) = best_combination_5(2,1);

%disp(results);
%wybranie najlepszego g-measure dla wszystkich danych testowych oraz delta
%i p na podstawie tego
the_best_g_measure = 0;
best_index = 0;

for ind = 1:size(results,2)
    if results(1,ind) > the_best_g_measure
        the_best_g_measure = results(1,ind);
        best_index = ind;
    end
end

%wyliczenie g-measure dla ostatecznego delta i p
fprintf("\n\nThe best is: %f with delta = %f and p = %f\n",results(1,best_index),results(2,best_index),results(3,best_index));
g_test1 = g_measure_test(results(2,best_index),results(3,best_index),test_data1);
g_test2 = g_measure_test(results(2,best_index),results(3,best_index),test_data2);
g_test3 = g_measure_test(results(2,best_index),results(3,best_index),test_data3);
g_test4 = g_measure_test(results(2,best_index),results(3,best_index),test_data4);
g_test5 = g_measure_test(results(2,best_index),results(3,best_index),test_data5);

%wyświetlenie ostatecznego wyniku
fprintf("for test data 1-5 g-measure with the best delta and p value are: \n1. %f \n2. %f \n3. %f \n4. %f \n5. %f\n",...
    g_test1,g_test2,g_test3,g_test4,g_test5);


