%% Code start
% Author: Alejandro Alvaro, 2023-2024

function [Ktt, Kbb, Ktb, Kxx] = kinconsti2b(e, a, ca, f, cf, Nb)
    % kinconsti2b Function to obtain the additional geometrical constants that
    %             affect the displacement of the damper extremity due to the
    %             out-of-plane movements
    %
    % SUMMARY:
    % This function computes the quadratic terms related to the out-of-plane
    % movements of a damper extremity for a rotor blade system. It takes in
    % various geometric parameters and outputs the quadratic terms in theta,
    % beta, theta-beta interaction, and xi.
    %
    % Input:
    %       * e : Blade flap offset, [m]
    %       * a : Chordwise offset from e of point A_i, [m]
    %       * ca : Spanwise offset from e of point A_i, [m]
    %       * f : Length of damper arm F_i, [m]
    %       * cf : Spanwise offset from e of point CF_i, [m]
    %       * Nb : Number of blades, [-]
    % Output:
    %       * Ktt : Quadratic term in theta
    %       * Kbb : Quadratic term in beta
    %       * Ktb : Quadratic term in theta-beta
    %       * Kxx : Quadratic term in xi

    dpsi = 2*pi/Nb;     % Angle between blades

    % Symbolic variables
    syms xi real        % Lead-lag angle
    syms delta real     % Orientation arm angle
    syms theta real     % Pitch angle
    syms betad real     % Flap angle

    %% theta, beta and xi
    % Kinematic model definition

    % Rotation matrix between local angle of damper arm and reference position of damper
    Rf32 = [cos(delta) -sin(delta) 0;
            sin(delta) cos(delta) 0;
            0 0 1];
    
    % Rotation matrix between cylindrical damper axes and lead-lag hinge axes
    Rf21 = [0 1 0;
            -1 0 0;
            0 0 -1];
    
    % Rotation matrix between lead-lag hinge axes and reference chosen for the kinematic model
    Rf10 = [cos(pi/2-dpsi) sin(pi/2-dpsi) 0;
            -sin(pi/2-dpsi) cos(pi/2-dpsi) 0;
            0 0 1];

    % Position of the damper arm in RF 3
    fv = [f 0 0]';
    Oc = [cf 0 0]';
    Oe = [0 e 0]';

    % Position of damper arm in RF 0
    fv = Rf10 * (Oe + Rf21 * (Oc + Rf32 * fv));

    % Position of point A in RF 3
    av = [ca a 0]';
    
    % Rotation due to beta
    Ra10b = [cos(betad) 0 -sin(betad);
             0 1 0;
             sin(betad) 0 cos(betad)];
    
    % Rotation due to xi
    Ra10x = [cos(xi) sin(xi) 0;
            -sin(xi) cos(xi) 0;
            0 0 1];
    
    % Rotation due to theta
    Ra10t = [1 0 0;
             0 cos(theta) -sin(theta);
             0 sin(theta) cos(theta)];
    
    Ra10 = Ra10x * Ra10b * Ra10t;
    
    % Position of point A in RF 0
    av = [e 0 0]' + Ra10 * av;

    % Distance between point A_i and F_i+1
    AF = fv - av;

    % Function to be linearized
    laf = sqrt(AF' * AF);

    % First order derivatives
    laf_d = diff(laf, delta);    % _delta
    laf_x = diff(laf, xi);       % _xi
    laf_t = diff(laf, theta);    % _theta
    laf_b = diff(laf, betad);    % _beta

    % Linear expansion
    % d_L ~ d(0) +SUM(di xi)
    % d_L ~ d0 + d1delta + d2xi + d3theta + d4beta
    % NOTE: d2/d1 is exactly equal to the value obtained in i2bfun
    d0 = subs(laf, [delta betad theta xi], [0 0 0 0]);
    d1 = double(subs(laf_d, [delta betad theta xi], [0 0 0 0]));
    d2 = double(subs(laf_x, [delta betad theta xi], [0 0 0 0]));
    d3 = subs(laf_t, [delta betad theta xi], [0 0 0 0]); % Expected zero
    d4 = subs(laf_b, [delta betad theta xi], [0 0 0 0]); % Expected zero

    % Quadratic terms
    % d_q ~ d_L + 1/2! SUM(dij xi xj)

    % Derivatives in delta
    laf_dd = diff(laf_d, delta); % _delta,delta
    laf_dx = diff(laf_d, xi);    % _delta,xi
    laf_dt = diff(laf_d, theta); % _delta,theta
    laf_db = diff(laf_d, betad); % _delta,beta

    % Derivatives in xi
    laf_xx = diff(laf_x, xi);    % _xi,xi
    laf_xt = diff(laf_x, theta); % _xi,theta
    laf_xb = diff(laf_x, betad); % _xi,beta

    % Derivatives in theta
    laf_tt = diff(laf_t, theta); % _theta,theta
    laf_tb = diff(laf_t, betad); % _theta,beta

    % Derivatives in beta
    laf_bb = diff(laf_b, betad); % _beta,beta
    laf_bt = diff(laf_b, theta); % _beta,theta

    % Evaluation of terms around equilibrium condition
    % * delta
    d11 = double(subs(laf_dd, [delta betad theta xi], [0 0 0 0]));
    d12 = double(subs(laf_dx, [delta betad theta xi], [0 0 0 0]));
    d13 = subs(laf_dt, [delta betad theta xi], [0 0 0 0]); % Expected 0
    d14 = subs(laf_db, [delta betad theta xi], [0 0 0 0]); % Expected 0
    % * xi
    d22 = double(subs(laf_xx, [delta betad theta xi], [0 0 0 0]));
    d23 = double(subs(laf_xt, [delta betad theta xi], [0 0 0 0])); % Expected 0
    d24 = double(subs(laf_xb, [delta betad theta xi], [0 0 0 0])); % Expected 0
    % * theta
    d33 = double(subs(laf_tt, [delta betad theta xi], [0 0 0 0]));
    d34 = double(subs(laf_tb, [delta betad theta xi], [0 0 0 0])); % Cross-coupling term
    % * beta
    d44 = double(subs(laf_bb, [delta betad theta xi], [0 0 0 0]));
    d43 = double(subs(laf_bt, [delta betad theta xi], [0 0 0 0])); % Cross-coupling term

    % Since it is assumed the damper around the reference condition must
    % maintain its length all other terms must cancel each other out
    % A relationship can be obtained as:
    % delta_xi = -d2/d1 xi
    % delta_theta = -d3/d1 theta
    % delta_beta = -d4/d1 beta
    % And the respective for the higher order terms
    % Bear in mind that second order derivatives of the same variable must be
    % multiplied by a factor of 1/2!, while cross derivatives do not have it.

    % Second order xi term: Positive xi(<0) induces a decrease in delta_f
    Kxx = double(-1/2 * d22 / d1);
    % Second order theta term: |theta| increases delta_f >0
    Ktt = double(-1/2 * d33 / d1);
    % Second order beta term: |beta| decreases delta_f<0
    Kbb = double(-1/2 * d44 / d1);
    % Cross-coupling between beta and theta
    Ktb = double(-d34 / d1);
end
