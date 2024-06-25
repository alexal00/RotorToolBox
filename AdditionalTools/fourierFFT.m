%% Code start
% Author: Alejandro Alvaro, 2023-2024

function [a, b] = fourierFFT(Beta, npt, df, w, nF)
    % fourierFFT Calculate Fourier coefficients using FFT
    %
    % SUMMARY
    % This function calculates the integer number harmonics of a given FFT
    %
    % Inputs:
    %       * Beta: FFT of a signal
    %       * npt: Number of points in the time history from the signal
    %       * df: Minimum frequency resolution
    %       * w: Oscillation frequency in reality omega
    %       * nF: Number of harmonics to obtain
    % Outputs:
    %       * a: Coefficients for the cosine terms
    %       * b: Coefficients for the sine terms
    %
    % See also: computeFFT, fourierseriestrapz

    counter = 0;            % Harmonic number counter
    sz = size(Beta, 2);
    % Initialize harmonic vectors
    a = zeros(nF + 1, sz); 
    b = zeros(nF + 1, sz);
    
    while counter <= nF
        % Store index of the corresponding integer multiple of the
        % fundamental frequency
        ii = round(counter * w / (2 * pi * df)) + 1;
        % Extract cosine and sine terms from Fourier Series given in FFT
        if counter == 0
            a(counter + 1, :) = real(Beta(ii, :)) / npt;
            b(counter + 1, :) = -imag(Beta(ii, :));
        else
            a(counter + 1, :) = real(Beta(ii, :)) / (npt / 2);
            b(counter + 1, :) = -imag(Beta(ii, :)) / (npt / 2);
        end
        counter = counter + 1;
    end
end
