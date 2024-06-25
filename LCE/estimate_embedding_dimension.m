function m = estimate_embedding_dimension(x, tau, max_dim, Rtol, Atol)
    % x: Time series data (each row is a separate DOF)
    % tau: Time delay
    % max_dim: Maximum embedding dimension to consider
    % Rtol: Tolerance threshold for distance ratio
    % Atol: Attractor tolerance threshold

    [num_dofs, N] = size(x);
    fnn_ratio = zeros(max_dim, 1);

    for m = 1:max_dim
        % Reconstruct phase space with dimension m for all DOFs combined
        M = N - (m - 1) * tau;
        Y = zeros(M, m * num_dofs);
        for dof = 1:num_dofs
            for i = 1:m
                Y(:, (dof-1)*m + i) = x(dof, (1:M) + (i-1) * tau);
            end
        end

        % Calculate distances and find nearest neighbors
        distances = pdist2(Y, Y);
        for i = 1:M
            distances(i, i) = Inf; % Exclude self-matching
        end
        [~, nearest_indices] = min(distances, [], 2);

        % Calculate the proportion of false nearest neighbors
        fnn = 0;
        for i = 1:M
            j = nearest_indices(i);
            if i + tau <= M && j + tau <= M % Ensure indices are within bounds
                d_m = norm(Y(i, :) - Y(j, :));
                d_m1 = norm([Y(i, :), reshape(x(:, i + m * tau), [], 1)'] - [Y(j, :), reshape(x(:, j + m * tau), [], 1)']);
                if (d_m1 / d_m > Rtol) || d_m1-d_m > Atol
                    fnn = fnn + 1;
                end
            end
        end
        fnn_ratio(m) = fnn / M;
    end

    % Find the dimension where FNN ratio first drops below a threshold
    threshold = 0.001;
    m = find(fnn_ratio < threshold, 1);
    if isempty(m)
        m = max_dim; % If no dimension meets the threshold, use max_dim
    end
    % m = 2*size(x,1)+1;
end