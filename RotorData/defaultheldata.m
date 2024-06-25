function data = defaultheldata
% Data for verification:
% helicopter basic parameters
R = 5.5; data.R = R;
Omega = 40.; data.Omega =Omega;
b = 4; data.b = b;
e = 0.04*R; data.e = e;
Mb = 94.9; data.Mb = Mb;
% uniform blade assumption
S_beta = Mb*(R - e)/2; data.Sb = S_beta;
I_beta = Mb*(R - e)^2/3; data.Ib = I_beta;
K_beta = 0.; data.Kb = K_beta;
% global parameters (used later to compute function and Jacobian matrix)
% global h xcg l Kh A v_tip sigma cla cd0 f Sbar lbar cmf clt St W rho
h = 2.; data.h =h; % m
xcg = 0.; data.xcg = xcg; % m
l = 6.; data.l = l;% m
Kh = b/2*(e*S_beta*Omega^2 + K_beta); data.Kh = Kh;% N m/radian
A = pi*R^2; data.A = A;% m^2
v_tip = R*Omega; data.v_tip=v_tip;% m/s
sigma = 0.08; data.sigma = sigma;
% C_Lalpha = 5.73; % typical coefficient (91% of 2*pi)
% C_Lalpha = 6.0447; % NACA 23012 at Mach 0-0.2 used in MBDyn
cla = 7.0760; data.cla=cla;% NACA 23012 at Mach 0.5 used in MBDyn
cd0 = 0.008; data.cd0=cd0;
f = .4; data.f =f;% m^2
Sbar = 2.; data.Sbar=Sbar;% m^2
lbar = 1.; data.lbar = lbar;% m
cmf = 0.02; data.cmf=cmf;
clt = 5.73; data.clt=clt;
St = 1.2; data.St=St;% m^2
W = 30000.; data.W=W;% N
rho = 1.225; data.rho=rho;% kg/m^3

end
% % initialize variables (initial guess)
% 
% T_D0 = W; % N
% H_D0 = W/20; % N
% R_f0 = W/20; % N
% M_f0 = 0.; % Nm
% P_c0 = 1000.; % N
% a_10 = 0.; % radian
% theta_00 = 8/180*pi; % radian
% B_10 = 0.; % radian
% gamma0 = 0.; % radian
% tau0 = 0.; 
% V_infty0 = 50;
% mu0 = V_infty0/v_tip;
% lambda0 = 0.02;
% alpha_D0 = 0.; % radian
% u0 = lambda0*v_tip; % m/s
% v10 = v_tip*sqrt(mu0^2 + lambda0^2); % m/s