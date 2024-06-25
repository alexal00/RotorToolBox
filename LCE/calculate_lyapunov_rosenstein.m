function largest_lyapunov_exponent = calculate_lyapunov_rosenstein(x, tau, m, fs)
    % x: Time series data (each row is a separate DOF)
    % tau: Time delay
    % m: Embedding dimension
    % fs: Sampling frequency

    [num_dofs, N] = size(x);
    M = N - (m - 1) * tau;  % Number of reconstructed vectors

    % Reconstruct phase space with dimension m for all DOFs combined
    Y = zeros(M, m * num_dofs);
    for dof = 1:num_dofs
        for i = 1:m
            Y(:, (dof-1)*m + i) = x(dof, (1:M) + (i-1) * tau);
        end
    end

    % Calculate MeanT
    mean_freq = meanfreq(x, fs);
    MeanT = ceil(fs / max(mean_freq));

    % Find nearest neighbors with temporal separation constraint
    distances = pdist2(Y, Y);
    for i = 1:M
        distances(i, abs([1:M] - i) <= MeanT) = Inf;  % Apply temporal separation constraint
        distances(i, i) = Inf;  % Exclude self-matching
    end
    [~, nearest_indices] = min(distances, [], 2);

    % Calculate divergence
    divergence = [];
    for i = 1:M
        j = nearest_indices(i);
        if (i + 1 <= M) && (j + 1 <= M)  % Ensure indices are within bounds
            div = norm(Y(i + 1, :) - Y(j + 1, :));
            if div > 0
                divergence = [divergence; log(div)];
            end
        end
    end

    % Compute the average divergence over all pairs and over time
    if isempty(divergence)
        largest_lyapunov_exponent = 0;
        return;
    end
    avg_divergence = mean(divergence);
    largest_lyapunov_exponent = avg_divergence / tau;
end