%% Code start
% Author: Alejandro Alvaro, 2023-2024

function geom = calculateKgeom(opt, e, damp, Nb)
    % calculateGeom Computes geometrical constants for innovative damping mechanisms
    %               proposed, based on the input options
    %
    % SUMMARY:
    % This function takes an input variable `opt` and computes various geometrical
    % properties, returning them in a structure `geom`.
    %
    % Input:
    %       * opt : Integer specifying the case (1, 2 or 3)
    %       * e : Blade flap offset, [m]
    %       * damp : Cell array of strings specifying damping types
    %       * Nb : Number of blades, [-]
    % Output:
    %       * geom : Structure containing the computed geometrical properties
    %
    % See also: i2bfun, ibfun, kinconsti2b

    % Compute geometric constants based on the value of opt
    if opt == 1 % original case
        geom.a = e / 2;
        geom.b = e / 2;
        geom.ca = e / 4;
        geom.cb = e / 4;
        geom.d = e / 2;
        geom.f = e / 2;
        geom.cd = e / 4;
        geom.cf = e / 4;
    elseif opt == 2 % modified case
        geom.a = e / 4;
        geom.b = e / 4;
        geom.ca = e / 4;
        geom.cb = e / 4;
        geom.d = e / 4;
        geom.f = e / 4;
        geom.cd = e / 2;
        geom.cf = e / 2;
    elseif opt == 3 % last version investigated
        geom.a = e/4;
        geom.b = e/4;
        geom.ca = e/4;
        geom.cb = e/4;
        geom.d = e/4;
        geom.f = e/4;
        geom.cd = e/4;
        geom.cf = e/4;
    else
        error('Invalid value for opt. It should be either 1, 2 or 3.');
    end

    % Initialize additional geometric constants
    geom.Kxidelta = 1;
    geom.Kxil = 1;

    % Check for 'i2b' damping type and calculate corresponding constants
    if any(strcmp(damp, 'i2b'))
        [geom.Kxidelta, k2, ~] = i2bfun(e, geom.a, geom.b, geom.ca, geom.cb, ...
                                        geom.d, geom.f, geom.cd, geom.cf, Nb);
        if geom.Kxidelta ~= k2
            warning('Non-symmetrical rotor, pay attention to geometrical factors');
        end
    end

    % Check for 'ib' damping type and calculate corresponding constants
    if any(strcmp(damp, 'ib'))
        [geom.Kxil, k2, ~] = ibfun(e, geom.a, geom.b, geom.ca, geom.cb, Nb);
        if geom.Kxil ~= -k2
            warning('Non-symmetrical rotor, pay attention to geometrical factors');
        end
    end
end
