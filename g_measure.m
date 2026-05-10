function [g] = g_measure(pred_labels, true_labels) %funkcja do wyliczenia g measure

    % True Positives: predicted 1 and actually 1
    TP = sum(pred_labels == 1 & true_labels == 1);

    % True Negatives: predicted -1 and actually -1
    TN = sum(pred_labels == -1 & true_labels == -1);

    % False Positives: predicted 1 but actually -1
    FP = sum(pred_labels == 1 & true_labels == -1);

    % False Negatives: predicted -1 but actually 1
    FN = sum(pred_labels == -1 & true_labels == 1);

    % Sensitivity (Recall)
    if (TP + FN) == 0
        TPR = 0;
    else
        TPR = TP / (TP + FN);
    end

    % Specificity
    if (TN + FP) == 0
        TNR = 0;
    else
        TNR = TN / (TN + FP);
    end

    % G-measure: geometric mean of TPR and TNR
    g = sqrt(TPR * TNR);
end