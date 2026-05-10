
% FDA project
%by:
%Jagoda Więce
%Paulina Pękala

% Task 1. For the dataset indicated by a teacher, determine the membership functions
% (the type of function will be specified for each section), which define the rule base of
% the TSK system to determine the delivery outcome.

%punkt dla abnormal i Normal

clc
close all
clear all

%% Data
% Saving extracted data from the file
data = readmatrix('FDA-data-e.xls');

% Dividing the data into individual vectors
% data_percetile = data(:,1); %bw
% data_apgar = data(:,2);
% data_ph = data(:,3); 
% E1 = data(:,4);
% E2 = data(:,5);
% E3 = data(:,6);

%% Data segregation
% Variables for Suspicious borderline values of each data type
sus_l = [5; 5; 7.1];
sus_u = [10; 7; 7.2];

% Creating empty vectors to avoid compilation problems
suspicous = zeros(size(data(:,size(sus_l))));
normal = zeros(size(data(:,size(sus_l))));
abnormal = zeros(size(data(:,size(sus_l))));

% Separation of data depending on variables l and u
for j=1:length(sus_l)
    if j == 1
        for i=1:length(data)
            if data(i,j) < sus_u(j) && data(i,j) > sus_l(j)
                suspicous(i,j) = data(i,j);
            elseif data(i,j) >= sus_u(j)
                normal(i,j) = data(i,j);
            elseif data(i,j) <= sus_l(j) 
                abnormal(i,j) = data(i,j);
            end
        end
    else
        for i=1:length(data)
            if data(i,j) < sus_u(j) && data(i,j) >= sus_l(j)
                suspicous(i,j) = data(i,j);
            elseif data(i,j) >= sus_u(j)
                normal(i,j) = data(i,j);
            elseif data(i,j) < sus_l(j) 
                abnormal(i,j) = data(i,j);
            end
        end
    end
end

% Rewrite the vectors leaving only nonzero values
for i=1:length(sus_l)
    nonzero_suspicous{i} = nonzeros(suspicous(:,i));
    nonzero_normal{i} = nonzeros(normal(:,i));
    nonzero_abnormal{i} = nonzeros(abnormal(:,i));
end


%% Quartiles
% Variables b and c, values of lower and higher quartiles
sus_b = zeros(size(sus_l));
sus_c = zeros(size(sus_l));

% Variables e and h, values for abnormal and normal quartiles
abn_e = zeros(size(sus_l));
norm_h = zeros(size(sus_l));

for i=1:length(sus_b)
    if any(nonzero_suspicous{i})
        sus_b(i) = quantile(nonzero_suspicous{i}, 0.25);
    end
    if any(nonzero_suspicous{i})
        sus_c(i) = quantile(nonzero_suspicous{i}, 0.75);
    end
    if any(nonzero_abnormal{i})
        abn_e(i) = quantile(nonzero_abnormal{i}, 0.75);
    end
    if any(nonzero_normal{i})
        norm_h(i) = quantile(nonzero_normal{i}, 0.25);
    end
end

%% Calculating line points
% Values y corresponding posision x of limit and quartile
lin_y = [0.5; 1];
names = {'Percentile', 'Adgar', 'pH'};

% Preparation of empty vectors
i = [0, 0, 0, 0];
sus_a = zeros(size(sus_l));
sus_d = zeros(size(sus_l));
norm_g = zeros(size(sus_l));
abn_f = zeros(size(sus_l));
lin_a = zeros(size(i));
lin_b = zeros(size(i));

%for i = 2
for i = 1:length(sus_l)
    % Calculation of the slope a and intercept b
    for j=1:4
        lin_x = [sus_l(i), sus_u(i), sus_l(i), sus_u(i); sus_b(i), sus_c(i), abn_e(i),norm_h(i)];
        if (lin_x(2,j) - lin_x(1,j)) == 0
            lin_a(j) = 0;
        else
            lin_a(j) = (lin_y(2) - lin_y(1)) / (lin_x(2,j) - lin_x(1,j));
        end
        lin_b(j) = lin_y(1) - lin_a(j) * lin_x(1,j);    
    end

    % If to check if we don't devide by zero
    if lin_a(1) ~= 0
        sus_a(i) = -lin_b(1) / lin_a(1);
    else
        sus_a(i) = sus_b(i);
    end
    if lin_a(2) ~= 0
        sus_d(i) = -lin_b(2) / lin_a(2);
    else
        sus_d(i) = sus_c(i);
    end
    if lin_a(3) ~= 0
        abn_f(i) = -lin_b(3) / lin_a(3);
    else
        abn_f(i) = abn_e(i);
    end
    if lin_a(4) ~= 0
        norm_g(i) = -lin_b(4) / lin_a(4);
    else
        norm_g(i) = norm_h(i);
    end

    % Start plotting
    figure; 

    %% Suspicious
    % Plot upward segment
    if any(nonzero_suspicous{i})
        sus_xu = linspace(sus_a(i), sus_b(i), 50);
        if lin_a(1) == 0
            sus_yu = linspace(0, 1, 50);
        else
            sus_yu = lin_a(1) * sus_xu + lin_b(1);
        end
        plot(sus_xu, sus_yu, '-y', 'LineWidth', 2, 'HandleVisibility', 'off');
        hold on;
    
        % Plot downward segment
        sus_xd = linspace(sus_c(i), sus_d(i), 50);
        if lin_a(2) == 0
            sus_yd = linspace(0, 1, 50);
        else
            sus_yd = lin_a(2) * sus_xd + lin_b(2);
        end
        plot(sus_xd, sus_yd, '-y', 'LineWidth', 2, 'HandleVisibility', 'off');
    
        % Plot horizontal connector
        sus_x = linspace(sus_b(i), sus_c(i), 50);
        sus_y = ones(size(sus_x));
        plot(sus_x, sus_y, '-y', 'LineWidth', 2, 'DisplayName', 'Suspicious');
    end

    %% Normal
    if any(nonzero_normal{i})
        % Plot upward segment
        norm_xu = linspace(norm_g(i), norm_h(i), 50);
        if lin_a(4) == 0
            norm_yu = linspace(0, 1, 50);
        else
            norm_yu = lin_a(4) * norm_xu + lin_b(4);
        end
        plot(norm_xu, norm_yu, '-g', 'LineWidth', 2, 'HandleVisibility', 'off');
        hold on;
    
        % Plot horizontal connector
        norm_x = linspace(norm_h(i), max(nonzero_normal{i}), 50);
        norm_y = ones(size(norm_x));
        plot(norm_x, norm_y, '-g', 'LineWidth', 2, 'DisplayName', 'Normal');
    end

    %% Abnormal
    if any(nonzero_abnormal{i})
        % Plot downward segment
        abn_xd = linspace(abn_e(i), abn_f(i), 50);
        if lin_a(3) == 0
            abn_yd = linspace(0, 1, 50);
        else
            abn_yd = lin_a(3) * abn_xd + lin_b(3);
        end
        plot(abn_xd, abn_yd, '-r', 'LineWidth', 2, 'HandleVisibility', 'off');
        hold on;
    
        % Plot horizontal connector
        abn_x = linspace(min(min(nonzero_abnormal{i}),min(norm_xu)), abn_e(i), 50);
        abn_y = ones(size(abn_x));
        plot(abn_x, abn_y, '-r', 'LineWidth', 2, 'DisplayName', 'Abnormal');
    end

    % Formatting
    xlabel('Fetal outcome attribute');
    ylabel('µa(x)');
    xlim([min(min(min(nonzero_abnormal{i}),min(norm_xu)),min(sus_xu)) max(max(max(nonzero_normal{i}),max(sus_xd)),max(abn_xd))]);
    title(['Membership Function of ', names{i}]);
    legend('Location','best');
    grid on;
    hold off;
end

%% Rules
% Reguły musimy stworzyć po trzech atrybutach, łącznie 27 reguł (etykiety jak w instrukcji abnormal state, suspicous state and normal state
% a newborn)
% Mamy utworzyć konkluzje z wartościami -1 1 i pomiędzy dla sus, zakładamy póki co 0.5

% % Preparation of outcome zeros array
% outcome = zeros(size(data(:,1)));
% 
% % Rule base
% for i = 1:length(data)
%     % Abnormal, if any of attributes indicates the abnormal state
%     if any(abnormal(i,:))
%         outcome(i) = 1;
%     % Normal, if two or more attributes indicate the normal and none indicates the abnormal state
%     elseif length(find(normal(i,:))) >= 2 && ~any(abnormal(i,:))
%         outcome(i) = -1;
%     % Suspicious, for all the remaining cases
%     else
%         outcome(i) = 0.5;
%     end
% end

%% The rest 
%Treshold that defines value (delta) that defines states where it really is abnormal or normal 
%(so there) won't be problems that both 1 and 0.01 are abnormal
%(-selta, delta) is then a suspicious state
%Expert 1, 2 or 3 to analyze, our section got E1!!
%g-measure (sqrt(sensitivity + specitivity))
%evolution strategy 
% So task 2 have simpler p(i) values assesment compared to task 3, in which we use an expert
%assign value p so it would fit with what an expert says
%sprzerzenie zwrotne dopoki nie dostosujemy wartosci

%% Rules implementation
% Table of only BW, AP and PH values
X = data(:,1:3);

% Arrangement of trapezoids limit values in [a b c d] structure
limit_values = struct();
fields = {'bw', 'ap', 'ph'};
for i = 1:3
    limit_values.(fields{i}).abn = [min(nonzero_abnormal{i}) - 0.1, min(nonzero_abnormal{i}), abn_e(i), abn_f(i)];
    limit_values.(fields{i}).sus = [sus_a(i), sus_b(i), sus_c(i), sus_d(i)];
    limit_values.(fields{i}).norm = [norm_g(i), norm_h(i), max(nonzero_normal{i}), max(nonzero_normal{i}) + 0.1];
end

% Parameter p to classify the delivery outcome as suspicious
p = 0.5;
%p = -0.5:0.25:0.5;

% Values of µa(x) for each state of every parameter
mi_values = AttachLabel(X, limit_values);
%% Task 2
% The final output value of the fuzzy model
y0 = zeros(size(X,1),1);
for i = 1:size(X,1)
    y0(i) = Rules(mi_values(i,:), p);
end

%% Functions
% Trapezoidal function - narzędzie, które jest w Fuzzy Logic Toolbox, ale nie byłam pewna na ile możemy z tego korzystać, więc tu jest nasza implementacja tej funkcji
function mi = trapmf(x, param)
    % Basically, pobiera parametry graniczne dla trapezu, oznaczenie jest jak w instrukcji dla sus
    a = param(1); b = param(2); c = param(3); d = param(4);
    % Zależnie od położenia w stosunku do wartości, obliczamy jego wysokość µa(x)
    if x <= a || x >= d
        mi = 0;
    elseif x >= b && x <= c
        mi = 1;
    elseif x > a && x < b
        mi = (x - a)/(b - a);
    elseif x > c && x < d
        mi = (d - x)/(d - c);
    else
        mi = 0;
    end
end

% Funkcja, która odpowiednio zbiera i przypisuje µa(x) dla każdej wartości każdej zmiennej u dzieci
% Powstała z tego funkcja, by ograniczyć powtarzalność
function mus = membership(x, param)
    mus = zeros(1,3);
    mus(1) = trapmf(x, param.abn);
    mus(2) = trapmf(x, param.sus);
    mus(3) = trapmf(x, param.norm);
end

% Funkcja przypisuje do jednej wielkiej tablicy określone µa(x) dla każdej wartości
% Przyjmuje wartości z danej kategorii oraz ograniczenia trapezoidalne, które tej kategorii dotyczą i zwraca odpowiednio obliczone wartości
function [mi_matrix] = AttachLabel(X, limit_values)
    n = size(X, 1);
    mi_matrix = zeros(n, 9);
    for i = 1:n
        bw = X(i,1);
        ap = X(i,2);
        ph = X(i,3);
        mi_matrix(i,1:3) = membership(bw, limit_values.bw);
        mi_matrix(i,4:6) = membership(ap, limit_values.ap);
        mi_matrix(i,7:9) = membership(ph, limit_values.ph);
    end
end

% Funkcja egzekwująca zasady według instrukcji, według wartości
% trapezoidalnych zebranych w funkcji 'membership'
function y0 = Rules(mus, p)
    mi_rules = zeros(27,1);
    y0_rules = zeros(27,1);
    idx = 1;
    
    % Pętla dla każdej wartości każdego stanu BW, AP i PH
    for i = 1:3
        for j = 1:3
            for k = 1:3
                % Zapisanie danych w sposób podobny do 'AttachLabel'
                mi_bw = mus(i);
                mi_ap = mus(3 + j);
                mi_ph = mus(6 + k);
                
                % Górna część działania y0 (where part)
                mi_rules(idx) = mi_bw * mi_ap * mi_ph;
    
                % Abnormal
                if i==1 || j==1 || k==1
                    y0_rules(idx) = 1;
                % Normal
                elseif sum([i==3, j==3, k==3]) >= 2
                    y0_rules(idx) = -1;
                % Suspicious
                else
                    y0_rules(idx) = p;
                end
                idx = idx + 1;
            end
        end
    end
    
    % Ostateczne obliczenie y0
    if sum(mi_rules) > 0
        y0 = sum(mi_rules .* y0_rules) / sum(mi_rules);
    else
        y0 = 0;
    end
end
