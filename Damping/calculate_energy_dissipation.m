function [total_energy, harmonic_energy, contribution_percent] = calculate_energy_dissipation(Md, xid, t_T, nf)
    % calculate_energy_dissipation Calculates energy dissipation over one
    %                              oscillation cycle or the word done by
    %                              the damper forces
    % Inputs:
    %       * Md : Moments or forces at the damper
    %       * xid : Relative angular velocity seen by the damper
    %       * t_T : Time vector over one revolution
    %       * n_F : Number of harmonics to use
    % Outputs:
    %       * total_energy : Total energy dissipated over one cycle
    %       * harmonic_energy : Energy dissipated by each harmonic
    %       * contribution_percent : Contribution of each harmonic to total energy dissipated

    % Preliminary parameters
    nT = length(t_T);                   % Time-steps per cycle
    dt = t_T(2)-t_T(1);                 % time step
    Fs = 1/dt;                          % Sampling frequency
    df = Fs/nT;                         % Increments of df for plotting
    T = t_T(end)-t_T(1);                % Integration period
    omega = 2*pi/T;                     % Oscillation frequency

    % Power over a cycle
    Pd = Md .* xid;

    % Energy dissipated in one cycle
    Ed = trapz(t_T, Pd);

    % Compute harmonic content

    % fft of the moments in the damper
    fftMd = fft(Md);

    % fft of the angular velocity in the damper
    fftxid = fft(xid);

    % harmonics: a_n*cos(nOmega*t)+b_n*sin(nOmega*t)
    [aMd, bMd] = fourierFFT(fftMd, nT, df, omega,nf);
    [axid, bxid] = fourierFFT(fftxid, nT,df,omega,nf);

    % Initialize arrays to store energy dissipated by each harmonic
    harmonic_energy = zeros(1, nf);

    % Loop through each harmonic
    for n = 0:nf
        % Calculate the power function for the nth harmonic
        if n == 0 % First harmonic (expected value is zero)
            power_n = aMd(n + 1, :) .* axid(n + 1, :) * ones(size(t_T));
        else % nth harmonic with n in N
            power_n = aMd(n + 1, :) .* axid(n + 1, :) .* cos(n * omega * t_T) .^ 2 + ...
                      bMd(n + 1, :) .* bxid(n + 1, :) .* sin(n * omega * t_T) .^ 2;
        end
        % Integrate the power function over one period to get energy dissipated by the nth harmonic
        energy_n = trapz(t_T, power_n);

        % Store the energy dissipated by the nth harmonic
        harmonic_energy(n + 1) = energy_n;
    end

    % Calculate total energy dissipated
    total_energy = sum(harmonic_energy);

    % Calculate contribution of each harmonic to total energy dissipated
    contribution_percent = (harmonic_energy / total_energy) * 100;
end
