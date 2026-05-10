function [y0] = Rules(mus, p)

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
