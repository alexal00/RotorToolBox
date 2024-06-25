function varargout = calculate_damping_hilbert(time, displacement, omega_n, varargin)
    % calculate_damping_hilbert calculates the damping ratio using the Hilbert transform
    %                           from the time history of a damped harmonic oscillator.
    %
    % Inputs:
    %       * time : A vector of time values
    %       * displacement : A vector of displacement values corresponding to the time values
    %       * omega_n : Fundamental natural frequency (rad/s)
    %       * varargin:
    %           * 'PlotFlag' (optional) - Boolean flag to enable plotting (default: false)
    %
    % Outputs:
    %       * zeta_est : Estimated damping ratio

    % Check that the input vectors are the same length
    if length(time) ~= length(displacement)
        error('Time and displacement vectors must be the same length');
    end

    % Default values
    plot_flag = false;

    % Parse varargin for 'PlotFlag'
    for i = 1:2:length(varargin)
        if strcmpi(varargin{i}, 'PlotFlag')
            plot_flag = varargin{i+1};
        end
    end

    % Apply Hilbert transform to get the analytic signal
    analytic_signal = hilbert(displacement);
    envelope = abs(analytic_signal);

    % Fit an exponential decay function to the envelope
    fit_func = @(b, t) b(1) * exp(-b(2) * t);  % Exponential decay function
    initial_guess = [max(envelope), 0.1];  % Initial guess for parameters

    % Define the objective function for fitting
    objective_func = @(b) sum((envelope - fit_func(b, time)).^2);

    % Perform non-linear least squares fitting
    opts = optimset('Display', 'off', 'TolX', 1e-8, 'TolFun', 1e-8, 'MaxFunEvals', 1000, 'MaxIter', 1000);
    beta = fminsearch(objective_func, initial_guess, opts);

    % Extract estimated damping ratio and amplitude
    A0_fit = beta(1);
    lambda_fit = beta(2);

    % Damping ratio estimation
    zeta_est = lambda_fit / omega_n;

    % Display results
    fprintf('Estimated Initial Amplitude: %.4f\n', A0_fit);
    fprintf('Estimated Damping Ratio (ζ): %.4f\n', zeta_est);

    % Plot the time history, envelope, and fitted envelope if 'PlotFlag' is true
    if plot_flag
        figure;
        plot(time, displacement);
        hold on;
        plot(time, envelope, 'r');
        plot(time, fit_func(beta, time), 'g--', 'LineWidth', 2);
        xlabel('Time (s)');
        ylabel('Displacement (m)');
        title('Damped Harmonic Oscillator with Envelope');
        legend('Displacement (x)', 'Envelope', 'Fitted Envelope');
        grid on;
        hold off;
    end

    % Output arguments
    varargout{1} = zeta_est;
end

