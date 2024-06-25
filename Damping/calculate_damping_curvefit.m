function varargout = calculate_damping_curvefit(time, displacement, omega_n, varargin)
    % calculate_damping_curvefit This function calculates the damping ratio using curve 
    %                            fitting from the time history of a damped harmonic 
    %                            oscillator.
    %
    % Inputs:
    %       * time : A vector of time values
    %       * displacement : A vector of displacement values corresponding to the time values
    %       * omega_n : Fundamental natural frequency (rad/s)
    %       * varargin:
    %           * 'PlotFlag' (optional) : Boolean flag to enable plotting (default: false)
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
    idx = find(displacement==max(displacement))-1;
    % Truncate the signals to the first peak
    time = time(idx:end)-time(idx);
    displacement = displacement(idx:end);
    % Fit an exponential decay function to the displacement
    fit_func = @(b, t) b(1) * exp(-b(2) * t);  % Exponential decay function
    initial_guess = [max(displacement), 0.1];  % Initial guess for parameters
    [peaks,locs] = findpeaks(displacement,time,"MinPeakDistance",1.1);
    
    % Define the objective function for fitting
    objective_func = @(b) sum((peaks - fit_func(b, locs)).^2);

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

    % Plot the time history and fitted curve if 'PlotFlag' is true
    if plot_flag
        figure;
        plot(time, displacement);
        hold on;
        plot(time, fit_func(beta, time), 'r--', 'LineWidth', 2);
        xlabel('Time (s)');
        ylabel('Displacement (m)');
        title('Damped Harmonic Oscillator with Fitted Curve');
        legend('Displacement (x)', 'Fitted Curve');
        grid on;
        hold off;
    end

    % Output argument
    varargout{1} = zeta_est;
end
