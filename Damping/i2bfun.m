function [k2f,varargout]=i2bfun(e,a,b,c_a,c_b,d,f,c_d,c_f,Nb,varargin)
% i2bfun Function to obtain the geometrical parameter that relates displacement 
%       of damper arms (D_i and F_i) with lead-lag angle of the adjacent blades
%       (xi_i-1 and xi_i+1)
% Input:
%       * e : Blade flap offset, [m]
%       * a : Chordwise offset from e of point A_i, [m]
%       * b : Chordwise offset from e of point B_i, [m]
%       * c_a : Spanwise offset from e of point A_i, [m]
%       * c_b : Spanwise offset from e of point B_i, [m]
%       * d : Lenght of damper arm D_i, [m]
%       * f : Lenght of damper arm F_i, [m]
%       * c_d : Spanwise offset from e of point CD_i, [m]
%       * c_f : Spanwise offset from e of point CF_i, [m]
%       * Nb : Number of blades, [-]
% Varargin:
%       * xi_E: Equilibrium lead-lag angle, [rad]
%       * deltaF_E: Prestress on the damper arm F, [rad]
%       * deltaD_E: Prestress on the damper arm D, [rad]
% Output:
%       * k2d: Geometrical relationship between the delta_D and xi_i+1
% optional output:
%       * k2f: Geometrical relationship between the delta_F and xi_i-1
%       * C_R: Damping matrix in rotating coordinates

minArgs = 10;
maxArgs = 13;
narginchk(minArgs,maxArgs)

if nargin>10
    xi1_E = varargin{1};
    if nargin >11
        deltaF_E = varargin{2};
        if nargin >12
            deltaD_E = varargin{3};
        end
    end
else
    xi1_E = 0.;
    deltaF_E = 0.;
    deltaD_E = 0.;
end

%% Declaration of variables
% syms a b f d c_a c_b c_f c_d  Nb e real positive
syms xi1 xi3 deltad2 deltaf2 real

deltapsi = 2*pi/Nb;
%%
A = [-a;c_a;0];
Ra21 = [cos(xi1) sin(xi1) 0;...
        -sin(xi1) cos(xi1) 0;...
        0 0 1]; 
Ra10 = [cos(deltapsi) sin(deltapsi) 0;...
        -sin(deltapsi) cos(deltapsi) 0;...
        0 0 1];

A = Ra10*([0;e;0]+Ra21*A);

B = [b;c_b;0];

Rb21 = [cos(xi3) sin(xi3) 0;...
        -sin(xi3) cos(xi3) 0;...
        0 0 1]; 
Rb10 = [cos(deltapsi) -sin(deltapsi) 0;...
        sin(deltapsi) cos(deltapsi) 0;...
        0 0 1];
B = Rb10*([0;e;0]+Rb21*B);

D = [d;0;0];
Rd21 = [cos(deltad2) -sin(deltad2) 0;...
        sin(deltad2) cos(deltad2) 0;...
        0 0 1]; 
Rd20 = [0 1 0;...
        -1 0 0;...
        0 0 1];
D = [0;e;0]+Rd20*([c_d;0;0]+Rd21*D);

F = [f;0;0];
Rf21 = [cos(deltaf2) -sin(deltaf2) 0;...
        sin(deltaf2) cos(deltaf2) 0;...
        0 0 1]; 
Rf20 = [0 1 0;...
        -1 0 0;...
        0 0 1];
F = [0;e;0]+Rf20*([c_f;0;0]+Rf21*F);
%%
daf = F-A;
daf_n =sqrt(daf'*daf);
daf1 = subs(diff(daf_n,xi1),[xi1 deltaf2],[xi1_E deltaF_E]);
daf2 = subs(diff(daf_n,deltaf2),[xi1 deltaf2],[xi1_E deltaF_E]);

k2f = double(-daf1/daf2);

dbd = D-B;
dbd_n = sqrt(dbd'*dbd);
dbd1 = subs(diff(dbd_n,xi3),[xi3 deltad2],[xi1_E deltaD_E]);
dbd2 = subs(diff(dbd_n,deltad2),[xi3 deltad2],[xi1_E deltaD_E]);

k2d = double(-dbd1/dbd2);
varargout{1} = k2d;
%%
R = [0 k2d;k2f 0];
C_Ri = R'*[1 -1]'*[1 -1]*R;
%%
C_R = zeros(Nb);
dof = zeros(2,Nb);
for ii=1:Nb
    nxt = mod(ii+1,Nb)+1;
    dof(:,ii)=[ii;nxt];
    C_R(dof(:,ii),dof(:,ii))=C_R(dof(:,ii),dof(:,ii))+C_Ri;
end

% C_R_double = simplifyFraction(subs(C_R,[b c_b a c_a c_d d c_f f],[e/2 e/4 e/2 e/4 e/4 e/2 e/4 e/2]));
C_R = double(C_R);
varargout{2}= C_R;

%if C_R(1,1)/2==k2d*k2f
%    disp(['Correct evaluation, Kxidelta=' num2str(k2f)])
%end

end