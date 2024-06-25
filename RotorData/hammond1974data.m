function data = hammond1974data
%% Hammond [1974] data
% Blade data
data.n_b = 4;        % Number of blades
data.m_b = 94.9;     % Blade mass, [kg]
data.S_b = 289.1;    % Static moment of inertia, [kg*m]
data.I_b = 1084.7;   % Inertia moment, [kg*m^2]
data.e = 0.3048;     % Hinge offset, [m]
data.k_xi = 0;       % Lag spring, [Nm/rad]
data.c_xi = 4067.5;  % Lag damper, [Nms/rad]
% data.c_xi = 10000;  % Lag damper, [Nms/rad]

% Hub/ airframe data
data.m_x = 8026.6;   % X-mass, [kg]
data.m_y = 3283.6;   % Y-mass, [kg]
data.k_x = 1240481.8;% X-spring, [N/m]
data.k_y = data.k_x;      % Y-spring, [N/m]
data.c_x = 51078.7;  % X-damper, [Ns/m]
data.c_y = data.c_x/2;    % Y-damper, [Ns/m]

data.nu_xi = sqrt(data.e*data.S_b/data.I_b);