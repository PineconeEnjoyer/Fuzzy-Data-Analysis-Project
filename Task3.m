% FDA project
%by:
%Jagoda Więce
%Paulina Pękala

%Task3

% 1. wylosować wartości p i d w przedziale startowym (od -0.5 do 0.5)
% jeśli któryś parametr wyleci wartością większą od 0.5 albo mniejszą od
% -0.5 to należy uciąć wartości do tych przedziałów
% 2. wykorzystanie evolutionary strategy wybranej metody

% zamiast mse, to g-measure użyty do walidacji (patrzymy by wynik był jak najlepszy), 
% podzielić dane tak samo jak w task 2, na training and testing data 5 razy

% value : p1 sigma_p1 p2 sigma_p2 p3 sigma_p3 p4 sigma_p4 delta sigma_delta
% inne p dla każdej kombinacji
% S S S p1
% S N S p2
% N S S p3
% S S N p4

clc
close all
clear all

%% Data import
data = readmatrix('FDA-data-e.xls');
matrix_membershipLevel = Task1;
%Task2;
matrix_ml_ex = [matrix_membershipLevel, data(:,4)]; % append expert labels
n = size(matrix_ml_ex, 1);

% Data for 5-fold cross-validation 
idx = randperm(n);
fold_size = floor(n / 5);
folds = cell(5,2);
for i = 1:5
    % Dividing data into 5 equal gropus of coplately different test data
    test_idx = idx((i-1)*fold_size+1 : min(i*fold_size, n));
    train_idx = setdiff(1:n, test_idx);
    folds{i,1} = matrix_ml_ex(train_idx,:);
    folds{i,2} = matrix_ml_ex(test_idx,:);
end

%% Evolution Strategy mu + lambda
% Preparation of needed ES parameter
generations = 10;
mu = 100;
lambda = 500;
n_params = 5;
tau1 = 1 / sqrt(2 * n_params);
tau2 = 1 / sqrt(2 * sqrt(n_params));

% First parent generation of generated 4p 4sigma values
p = -0.5 + rand(mu, n_params);
sigma = 0.05 + 0.1 * rand(mu, n_params);

best_G = -inf;
best_individual = [];

% Iteration to go through all generations
for gen = 1:generations
    offspring = zeros(lambda, n_params);
    offspring_sigma = zeros(lambda, n_params);
    G_scores = zeros(lambda,1);

    % Fitness score for parents in current generation
    parent_scores = zeros(mu, 1);
    for i = 1:mu
        G_folds = zeros(1,5);
        for fold = 1:5
            test_data = folds{fold,2};
            G_folds(fold) = g_measure_test_task3(p(i,5), p(i,1:4), test_data);
        end
        parent_scores(i) = mean(G_folds);
    end

    % Iteration for all offsprings in currect generation
    for i = 1:lambda
        parent_idx = randi(mu);
        p_vals = p(parent_idx, :);
        sigs = sigma(parent_idx, :);

        % Gaussian Mutation of children (adding random noise)
        child = p_vals + sigs .* randn(1, n_params);
        child = max(min(child, 0.5), -0.5); %bounds [-0.5, +0.5]
        child_sigma = sigs .* exp(tau1 * randn(1) + tau2 * randn(1, n_params));
        child_sigma = max(min(child_sigma, 0.5), 1e-8);

        % Fitness level for offsprings
        G_folds = zeros(1,5);
        for fold = 1:5
            test_data = folds{fold,2};
            G_folds(fold) = g_measure_test_task3(child(5), child(1:4), test_data);
        end

        G_scores(i) = mean(G_folds); %najlepszy z 20% lub wyróżnić weryfikującą, łagodna ocena modelu
        offspring(i,:) = child;
        offspring_sigma(i,:) = child_sigma;
    end

    % Combining parents and offsprings to sort out the best ones by the G-measure
    all_ind = [p; offspring];
    all_sig = [sigma; offspring_sigma];
    all_scores = [parent_scores; G_scores];

    [~, sorted_idx] = sort(all_scores, 'descend');
    p = all_ind(sorted_idx(1:mu), :);
    sigma = all_sig(sorted_idx(1:mu), :);

    % Best individual depending on current best G-measure
    if max(G_scores) > best_G
        best_G = max(G_scores);
        best_individual = offspring(G_scores == best_G, :);
    end

    % Stop criteria, if change is lower than the threshold
    fprintf('Generation %d: Parent = %f, Offspring = %f, Delta = %f\n', gen, max(parent_scores), max(G_scores), abs(max(parent_scores) - max(G_scores)));
    if abs(max(parent_scores) - max(G_scores)) < 1e-8
        break;
    end
end

fprintf('Best G-measure: %.4f\n', best_G);
fprintf('Best parameters: p1=%.2f, p2=%.2f, p3=%.2f, p4=%.2f, delta=%.2f\n', best_individual);
fprintf('Algorithm stopped after %d generations (out of %d)\n', gen, generations);

%% Finding y0 for all fetuses
% Children data
X_full = matrix_ml_ex(:, 1:9);
p_best = best_individual(1:4);

% Classifing each outcome by the given rules
y0_full = zeros(size(X_full, 1), 1);
for i = 1:size(X_full, 1)
    y0_full(i) = Rules_task3(X_full(i,:), p_best);
end

% Counting high informativeness signals
informativeness_threshold = 0.5;
high_informativeness_count = sum(abs(y0_full) > informativeness_threshold);

fprintf("Number of highly informative signals (|y0| > 0.5): %d out of %d samples\n", high_informativeness_count, length(y0_full));

%% Conclusions
task2_g = [0.875359 0.880965 0.880965 0.880965 0.878843];
task3_g = [0.8987 0.9019 0.8888 0.9036 0.9016];
x = [1 2 3 4 5];
plot(x, task2_g, '-square', 'LineWidth', 2, 'DisplayName', 'Grid Search');
hold on;
plot(x, task3_g, '-o', 'LineWidth', 2, 'DisplayName', 'Evolutionary Strategy');    
xlabel('Iteration');
ylabel('G-measure value');
title('Comparison of Final G-measure Values Across Methods');
legend('Location','best');
grid on;
hold off;

%% Functions
function y0 = Rules_task3(mus, p)
    mi_rules = zeros(27,1);
    y0_rules = zeros(27,1);
    idx = 1;

    % Loop for all values of BW, AP i PH
    for i = 1:3
        for j = 1:3
            for k = 1:3
                % The upper part of y0 equation (where part)
                mi = mus(i) * mus(3 + j) * mus(6 + k);
                mi_rules(idx) = mi;

                % Abnormal
                if i==1 || j==1 || k==1
                    y0_rules(idx) = 1;
                % Normal
                elseif sum([i==3, j==3, k==3]) >= 2
                    y0_rules(idx) = -1;
                % Suspicious
                else
                    y0_rules(idx) = choose_p_task3(i,j,k,p);
                end
                idx = idx + 1;
            end
        end
    end

    % Final value y0
    if sum(mi_rules) > 0
        y0 = sum(mi_rules .* y0_rules) / sum(mi_rules);
    else
        y0 = 0;
    end
end

function p = choose_p_task3(i,j,k,p_vec)
    % p1 for S S S
    if isequal([i j k],[2 2 2])
        p = p_vec(1);
    % p2 for S N S
    elseif isequal([i j k],[2 3 2])
        p = p_vec(2);
    % p3 for N S S
    elseif isequal([i j k],[3 2 2])
        p = p_vec(3);
    % p4 for S S N
    elseif isequal([i j k],[2 2 3])
        p = p_vec(4);
    end
end

function g = g_measure_test_task3(delta, p, matrix)
    % Calculating y0 value to compare with delta threshold 
    y0 = zeros(size(matrix,1),1);
    for i = 1:size(matrix,1)
        y0(i) = Rules_task3(matrix(i,:), p);
    end

    % Predicted state labels
    pred = ones(size(y0));
    pred(y0 <= delta) = -1;

    % G-measure value
    g = g_measure(pred, matrix(:,10));
end

