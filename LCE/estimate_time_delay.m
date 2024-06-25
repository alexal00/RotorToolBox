function tau = estimate_time_delay(x, max_lag)
    % x: Time series data (each row is a separate DOF)
    % max_lag: Maximum lag to consider

    [num_dofs, ~] = size(x);
    ami = zeros(num_dofs, max_lag);

    for dof = 1:num_dofs
        for lag = 1:max_lag
            ami(dof, lag) = average_mutual_information(x(dof, :), lag);
        end
    end

    % Find the first minimum of AMI for each DOF and take the average
    [~, tau] = min(ami, [], 2);
    tau = round(mean(tau));
end