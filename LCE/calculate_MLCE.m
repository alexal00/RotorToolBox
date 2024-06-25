function MLCE = calculate_MLCE(x, max_lag, max_dim, Rtol, Atol, fs)
    % x: Time series data (each row is a separate DOF)
    % max_lag: Maximum lag to consider for estimating time delay
    % max_dim: Maximum embedding dimension to consider
    % Rtol: Tolerance threshold for distance ratio
    % Atol: Attractor tolerance threshold
    % fs: Sampling frequency

    % Estimate time delay using AMI
    tau = estimate_time_delay(x, max_lag);

    % Estimate embedding dimension using FNN
    m = estimate_embedding_dimension(x, tau, max_dim, Rtol, Atol);

    % Calculate Lyapunov exponent using the Rosenstein method with temporal separation constraint
    MLCE = calculate_lyapunov_rosenstein(x, tau, m, fs);
end