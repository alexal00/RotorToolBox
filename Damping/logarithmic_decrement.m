%% Code start
% Author: Alejandro Alvaro, 2023-2024

function varargout = logarithmic_decrement(time, displacement, varargin)
    % logarithmic_decrement This function calculates the damping ratio and optionally the
    %                       logarithmic decrement from the time history of a damped 
    %                       harmonic oscillator.
    %
    % Inputs:
    %       * time: A vector of time values
    %       * displacement: A vector of displacement values corresponding to the time values
    %       * varargin:
    %           * 'PlotFlag' (optional): Boolean flag to enable plotting (default: false)
    %           * 'MinPeakDistance' (optional): Minimum peak distance for findpeaks (default: [])
    %
    % Outputs:
    %       * zeta_est: Estimated damping ratio
    %       * delta_avg (optional): Average logarithmic decrement
    % Example:
    % Example script to generate time history and calculate damping
    % % Parameters
    % M = 1.0;  % mass
    % K = 20.0;  % stiffness
    % C = 0.5;  % damping coefficient
    % 
    % % Define the system of ODEs
    % damped_oscillator = @(t, y) [y(2); -(C/M)*y(2) - (K/M)*y(1)];
    % 
    % % Initial conditions
    % x0 = 1.0;  % initial displacement
    % v0 = 0.0;  % initial velocity
    % initial_conditions = [x0; v0];
    % 
    % % Time span for the solution
    % t_span = [0 20];
    % t_eval = linspace(t_span(1), t_span(2), 1000);
    % 
    % % Solve the ODE
    % [t, y] = ode45(damped_oscillator, t_eval, initial_conditions);
    % 
    % % Extract displacement
    % x = y(:, 1);
    % 
    % % Calculate damping ratio and logarithmic decrement
    % % Set plot_flag to true to enable plotting
    % [zeta_est, delta_avg] = logarithmic_decrement(t, x,'plotflag',true);
    
    % Check that the input vectors are the same length
    if length(time) ~= length(displacement)
        error('Time and displacement vectors must be the same length');
    end

    % Default values
    plot_flag = false;
    min_peak_distance = [];

    % Parse varargin for 'PlotFlag' and 'MinPeakDistance'
    for i = 1:2:length(varargin)
        if strcmpi(varargin{i}, 'PlotFlag')
            plot_flag = varargin{i+1};
        elseif strcmpi(varargin{i}, 'MinPeakDistance')
            min_peak_distance = varargin{i+1};
        end
    end

    % Find peaks
    if isempty(min_peak_distance)
        [peaks, locs] = findpeaks(displacement, time);
    else
        [peaks, locs] = findpeaks(displacement, time, 'MinPeakDistance', min_peak_distance);
    end
    
    % Process peaks using processVector
    [~, ~, peaks, idx] = processVector(peaks);
    locs = locs(idx);

    % Ensure there are enough peaks to calculate the logarithmic decrement
    if length(peaks) < 2
        error('Not enough peaks found to calculate the logarithmic decrement');
    end

    % Calculate logarithmic decrement
    delta = log(peaks(1:end-1) ./ peaks(2:end));

    % Calculate average logarithmic decrement
    delta_avg = mean(delta);

    % Calculate damping ratio
    zeta_est = delta_avg / sqrt(4 * pi^2 + delta_avg^2);

    % Plot the time history and peaks if 'PlotFlag' is true
    if plot_flag
        figure;
        plot(time, displacement);
        hold on;
        plot(locs, peaks, 'ro');
        xlabel('Time (s)');
        ylabel('Displacement (m)');
        title('Damped Harmonic Oscillator with Peaks');
        legend('Displacement (x)', 'Peaks');
        grid on;
        hold off;
    end

    % Output arguments
    varargout{1} = zeta_est;
    if nargout > 1
        varargout{2} = delta_avg;
    end
end
