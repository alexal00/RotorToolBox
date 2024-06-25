function [K, contributions] = LSkinconsti2bMBDyn(xi, theta, beta, delta_F)
    % Function to calculate the coefficients and contributions of each term using fmincon
    % Inputs:
    %       * xi : Time history of lead-lag angles of the ith blade
    %       * theta : Time history of pitch values of the ith blade
    %       * beta : Time history of falp values of the ith blade
    %       * delta_F : Time history of damper arm orientation D (values of
    %                   the i-1 blade) or F (values of i+1 blade)
    % Outputs:
    %       * K: Coefficients [K_xd, K_xi, K_td, K_bd, K_tb]
    %           * K_td : Quadratic term in theta
    %           * K_bd : Quadratic term in beta
    %           * K_tb : Quadratic term in theta-beta
    %           * K_xd : Quadratic term in xi
    %       * contributions: Percentage contributions of each term
    
    % Ensure inputs are column vectors
    xi = xi(:);
    theta = theta(:);
    beta = beta(:);
    delta_F = delta_F(:);

    % Initial guess for the coefficients
    K0 = ones(5, 1);

    % Objective function to minimize
    objective = @(K) sum((delta_F - (K(1) * xi + K(2) * xi.^2 + K(3) * theta.^2 + K(4) * beta.^2 + K(5) * theta .* beta)).^2);

    % Use fmincon to find the coefficients that minimize the objective function
    options = optimoptions('fmincon', 'Display', 'off');
    K = fmincon(objective, K0, [], [], [], [], [], [], [], options);

    % Calculate the predicted delta_D
    delta_D_predicted = K(1) * xi + K(2) * xi.^2 + K(3) * theta.^2 + K(4) * beta.^2 + K(5) * theta .* beta;

    % Calculate the total energy (integral of delta_D)
    total_energy = trapz(delta_D_predicted);

    % Calculate the contribution of each term
    contribution_xd = K(1) * xi;
    contribution_xi2 = K(2) * (xi.^2);
    contribution_theta2 = K(3) * (theta.^2);
    contribution_beta2 = K(4) * (beta.^2);
    contribution_theta_beta = K(5) * (theta .* beta);

    % Integrate each contribution
    integral_contribution_xd = trapz(contribution_xd);
    integral_contribution_xi2 = trapz(contribution_xi2);
    integral_contribution_theta2 = trapz(contribution_theta2);
    integral_contribution_beta2 = trapz(contribution_beta2);
    integral_contribution_theta_beta = trapz(contribution_theta_beta);

    % Calculate the percentage contribution of each term
    percentage_contribution_xd = (integral_contribution_xd / total_energy) * 100;
    percentage_contribution_xi2 = (integral_contribution_xi2 / total_energy) * 100;
    percentage_contribution_theta2 = (integral_contribution_theta2 / total_energy) * 100;
    percentage_contribution_beta2 = (integral_contribution_beta2 / total_energy) * 100;
    percentage_contribution_theta_beta = (integral_contribution_theta_beta / total_energy) * 100;

    % Create the contributions vector
    contributions = [percentage_contribution_xd, percentage_contribution_xi2, ...
                     percentage_contribution_theta2, percentage_contribution_beta2, ...
                     percentage_contribution_theta_beta];
end

