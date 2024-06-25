function [Kxila,varargout]=ibfun(e,a,b,c_a,c_b,Nb,varargin)
% ibfun Function to obtain the geometrical parameter that relates displacement 
%       of damper ends (A_i and B_i+1) with lead-lag angle of the adjacent blades
%       (xi_i and xi_i+1)
% Input:
%       * e : Blade flap offset, [m]
%       * a : Chordwise offset from e of point A_i, [m]
%       * b : Chordwise offset from e of point B_i, [m]
%       * c_a : Spanwise offset from e of point A_i, [m]
%       * c_b : Spanwise offset from e of point B_i, [m]
%       * Nb : Number of blades, [-]
% Varargin:
%       * xi_E: Equlibrium lead-lag angle, [rad]
% Output:
%       * Kxila: Geometrical relationship between the rod length and xi_i
% optional output:
%       * Kxilb: Geometrical relationship between the rod length and xi_i+1
%       * C_R: Damping matrix in rotating coordinates
% NOTE: The length of linear damper is d_i = d_0 + Kxila*xi_i + Kxilb*xi_i+1

minArgs = 6;
maxArgs = 7;

narginchk(minArgs,maxArgs)
if nargin>6
    xi1_E = varargin{1};
else
    xi1_E = 0.;
end
%% Declaration of variables
syms L_bar real positive
syms xi1 xi2 real

deltapsi = 2*pi/Nb;
phi = (pi-deltapsi)/2;
Le=  2*e*sin(deltapsi/2);
%% Initial generic positions
B = [b; c_b; 0];
A = [-a; c_a; 0];

Rb21 = [cos(xi2) sin(xi2) 0;...
        -sin(xi2) cos(xi2) 0;...
        0 0 1];
Rb10 = [sin(phi) -cos(phi) 0;
        cos(phi) sin(phi) 0;
        0 0 1];
Rb20 = simplify(Rb10*Rb21);
B = Rb20*B;
Ra21 = [cos(xi1) sin(xi1) 0;...
        -sin(xi1) cos(xi1) 0;...
        0 0 1];
Ra10 = [sin(phi) cos(phi) 0;
        -cos(phi) sin(phi) 0;
        0 0 1];
Ra20 = simplify(Ra10*Ra21);
A = [Le;0;0]+Ra20*A;

%% Derivation of the damping expression
li = B-A;
li_n = (li'*li)^0.5;
d_0 = double(subs(li_n,[xi1 xi2],[0,0]));
d_1 = double(subs(diff(li_n,xi1),[xi1 xi2],[xi1_E,xi1_E]));
Kxila = d_1;
d_2 = double(subs(diff(li_n,xi2),[xi1 xi2],[xi1_E,xi1_E]));
Kxilb = d_2;
varargout{1} = Kxilb;

C_Ri = [d_1 d_2]'*[d_1 d_2];
C_R = sym(zeros(Nb));
% dof = zeros(2,Nb);
for ii=1:Nb
    nxt = mod(ii,Nb)+1;
    dof=[ii;nxt];
    C_R(dof,dof)=C_R(dof,dof)+C_Ri;
end
C_R = double(C_R);
varargout{2} = C_R;
%if abs(C_R(1,1)-(Kxila^2+Kxilb^2))<=1e-10
    %disp(['Correct evaluation, Kxil=' num2str(Kxila)])
%end
end