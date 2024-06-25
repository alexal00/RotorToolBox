%% Code start
% Author: Alejandro Alvaro, 2023-2024

function [P1,f] = computeFFT(x,t)
    % computeFFT Compute One-sided Power Spectrum of a function
    %
    % SUMMARY:
    % This functions calculates the One-Sided Power Spectrum of a given time
    % history alongside the frequency vector
    %
    % Input:
    %       * x: Time history
    %       * t: Vector of time
    % Output:
    %       * P1: One-sided Power Spectral Density
    %       * f: Frequency vector
    
    dt = t(2)-t(1);
    L = length(t);
    if istable(x)
        x = table2array(x);
    end
    X = fft(x,L);
    
    P2 = abs(X/L);
    P1 = P2(1:L/2+1,:);
    P1(2:end-1,:) = 2*P1(2:end-1,:);
    
    Fs = 1/dt; % Sampling frequency
    df = Fs/L;    % Increments of df for plotting
    
    f = df*(0:L/2); % generate frequency vector for FFT plot
end