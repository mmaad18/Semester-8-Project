%% Their example
syms th thd g m l k 
L = m*l^2*thd^2/2 + m*g*l*cos(th); % Lagrangian 
X = {th thd}; % Vector of generalized coordinates 
Q_i = {0}; Q_e = {0}; % No generalized forces 
R = k*thd^2/2; % Friction term 
par = {g m l k}; % System parameters 
% Create symbolic differential equations ? 
% ?and the corresponding 'm'ATLAB function and 's'imulink block 
VF = EulerLagrange(L,X,Q_i,Q_e,R,par,'m','s'); 

%% Our example
syms theta thetad alpha alphad l_r l_rd
syms m_h I_h m_w I_w l m_r r_w g

I_r = m_r*(2*l_r*l*cos(pi-alpha)-l_r^2-l^2);

%T_w = 1/2*m_w*xd^2 + 1/2*I_w*(xd/r_w)^2;
T_h = 1/2*m_h*(-2*l*thetad*cos(theta) + l^2*thetad^2);
T_r = 1/2*m_r*(l^2*thetad^2 + 2*l*thetad*l_r*alphad*cos(theta-alpha) + l_r^2*alphad^2) + 1/2*I_r*(thetad+alphad)^2;

U_h = m_h*g*l*cos(theta);
U_r = m_r*g*(l*cos(theta)-l_r*cos(alpha));

L = (T_w+T_h+T_r) - (U_h+U_r);

%L = 1/2*m_w*xd^2 + 1/2*I_w*xd/r_b + 1/2*m_h*(xd^2-2*l*xd*thetad*cos(theta)+l^2*thetad^2) + 1/2*I_h*thetad^2 + 1/2*m_r*l^2*thetad^2 + 2*l*thetad*l_r*alphad*cos(theta-alpha) + l_r^2*alphad^2 - m_h*g*l*cos(theta) - m_h*g*l*cos(theta) - m_r*g*(l*cos(theta)-l_r*cos(alpha));

X = {theta thetad alpha alphad l_r l_rd}; % Vector of generalized coordinates 

Q_i = {0 0 0}; Q_e = {0 0 0}; % No generalized forces 

R = 0; % Friction term 

par = {m_h I_h m_w I_w l m_r r_w g}; % System parameters 

VF = EulerLagrange(L,X,Q_i,Q_e,R,par,'m','s');

%%
theta_dot = VF(2)
alpha_dot = VF(4)
xd = VF(6)