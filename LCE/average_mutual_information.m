function ami = average_mutual_information(x, lag)
    % Compute average mutual information for a given lag
    x1 = x(1:end-lag);
    x2 = x(lag+1:end);

    pX1 = histcounts(x1, 'Normalization', 'probability');
    pX2 = histcounts(x2, 'Normalization', 'probability');
    pX1X2 = histcounts2(x1, x2, 'Normalization', 'probability');

    pX1 = pX1(pX1 > 0);
    pX2 = pX2(pX2 > 0);
    pX1X2 = pX1X2(pX1X2 > 0);

    Hx1 = -sum(pX1 .* log2(pX1));
    Hx2 = -sum(pX2 .* log2(pX2));
    Hx1x2 = -sum(pX1X2 .* log2(pX1X2));

    ami = Hx1 + Hx2 - Hx1x2;
end