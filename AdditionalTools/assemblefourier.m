%% Code start
% Author: Alejandro Alvaro, 2023-2024

function f_t = assemblefourier(a, b, Omega, t)
    % assemblefourier Assembles a Fourier series given the coefficients and angular frequency
    %
    % SUMMARY:
    % This function constructs a Fourier series using the provided cosine and sine coefficients
    % (a and b), the angular frequency (Omega), and the time vector (t). It returns the evaluated
    % Fourier series at each time point in t.
    %
    % Input:
    %       * a : Cosine coefficients of the Fourier series, array [N]
    %       * b : Sine coefficients of the Fourier series, array [N]
    %       * Omega : Angular frequency of the Fourier series, scalar [rad/s]
    %       * t : Time vector at which to evaluate the Fourier series, array [M]
    % Output:
    %       * f_t : Evaluated Fourier series at each time point in t, array [M]

    % Initialize the Fourier series evaluation vector to zeros with the same size as t
    f_t = zeros(size(t));
    
    % Loop over each coefficient to assemble the Fourier series
    for ii = 0:length(a)-1
        if ii == 0
            % The zeroth term (DC component) adds a constant value a(1)
            f_t = f_t + a(ii+1) * ones(size(t));
        else
            % Higher-order terms include cosine and sine components
            f_t = f_t + a(ii+1) * cos(ii * Omega * t) + b(ii+1) * sin(ii * Omega * t);
        end
    end

end
