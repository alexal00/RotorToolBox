%% Code start
% Author: Alejandro Alvaro, 2023-2024

function [a, b] = fourierseriestrapz(fun, t, tol, maxiter)
    % fourierseries Computes the Fourier series coefficients for a given function
    %
    % SUMMARY:
    % This function calculates the Fourier series coefficients (a and b) for a given 
    % periodic function `fun` over the time vector `t` using numerical integration. 
    % The computation iterates until the error is below the specified tolerance `tol` 
    % or the number of iterations exceeds `maxiter`.
    %
    % Input:
    %       * fun : Function values at discrete time points, array [M]
    %       * t : Time vector corresponding to the function values, array [M]
    %       * tol : Tolerance for the error in the Fourier series approximation, scalar
    %       * maxiter : Maximum number of iterations, scalar
    % Output:
    %       * a : Cosine coefficients of the Fourier series, array [N]
    %       * b : Sine coefficients of the Fourier series, array [N]

    % Initialize iteration counter
    niter = 1;
    
    % Initialize the approximation of the function with zeros
    betaT = zeros(size(fun));
    
    % Initialize error above tolerance to enter the loop
    err = 2 * tol;
    
    % Compute the period T and angular frequency Omega
    T = t(end) - t(1);
    Omega = 2 * pi / T;
    
    % Initialize coefficient arrays
    a = zeros(1, maxiter);
    b = zeros(1, maxiter);

    % Loop until error is within tolerance or max iterations reached
    while (err > tol && niter < maxiter)
        if niter == 1
            % Compute the zeroth Fourier coefficient (DC component)
            a(niter) = 1 / T * trapz(t, fun);
            b(niter) = 0;
        else
            % Compute the nth Fourier coefficients for cosine and sine terms
            f = fun .* cos((niter-1) * Omega * t');
            a(niter) = 2 / T * trapz(t, f);
            f = fun .* sin((niter-1) * Omega * t');
            b(niter) = 2 / T * trapz(t, f);
        end

        % Update the Fourier series approximation of the function
        betaT = betaT + a(niter) * cos((niter-1) * Omega * t') + b(niter) * sin((niter-1) * Omega * t');
        
        % Increment iteration counter
        niter = niter + 1;
        
        % Compute the error between the function and its Fourier series approximation
        err = sum(abs(fun - betaT));
    end

    % Trim the coefficient arrays to the actual number of iterations
    a = a(1:niter-1);
    b = b(1:niter-1);
end
