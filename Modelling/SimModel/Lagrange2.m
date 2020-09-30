% Pendulum_demo  This demo illustrates the usage of the EulerLagrange tool
%                from beginning to end. The system Lagrangian is defined,
%                the tool creates the corresponding MATLAB function, which 
%                is integrated using ode45. The plots show the state vector 
%                and the total energy of the system.
%
% Copyright 2015-2016 The MathWorks, Inc.
% Derive DE for pendulum

syms m1 l1 th1 th1_d;
syms m2 l2 th2 th2_d;
syms m3 l3 th3 th3_d;
syms g;

T1 = 0.5*m1*l1^2*th1_d^2;
T2 = 0.5*m2*(-l1*th1_d*sin(th1) - l2*th2_d*sin(th2))^2 ...
   + 0.5*m2*(l1*th1_d*cos(th1) + l2*th2_d*cos(th2))^2;
T3 = 0.5*m3*(-l1*th1_d*sin(th1) - l2*th2_d*sin(th2) - l3*th3_d*sin(th3))^2 ...
   + 0.5*m3*(l1*th1_d*cos(th1) + l2*th2_d*cos(th2) + l3*th3_d*cos(th3))^2;

T   = T1 + T2 + T3;

U1 = m1*g*l1*cos(th1);
U2 = m2*g*(l1*cos(th1) + l2*cos(th2));
U3 = m3*g*(l1*cos(th1) + l2*cos(th2) + l3*cos(th3));

V   = U1 + U2 + U3;

L   = T - V;
%E   = T + V;

X   = {th1 th1_d th2 th2_d th3 th3_d};

Q_i = {0 0 0}; Q_e = {0 0 0};
R   = 0;
par = {g m1 m2 m3 l1 l2 l3};

% Solve Lagrange equations and save DE as .m file
VF  = EulerLagrange(L,X,Q_i,Q_e,R,par,'m','Kugle_sys');

% Create Simulink block
%SimBlock  = EulerLagrange(L,X,Q_i,Q_e,R,par,'s','Kugle_sys');

% Solve DE numerically using ode45
m1_num   = 1;
m2_num   = 1;
m3_num   = 1;

g_num   = 9.81;

l1_num   = 1;
l2_num   = 1;
l3_num   = 1;

%timespan
tspan   = [0 90];

Y0      = [180 0 180 0 180 0]*pi/180;
options = odeset('RelTol',1e-8);
% Use created .m file to solve DE 
[t, Y]  = ode45(@Kugle_sys,tspan,Y0,options, ...
            m1_num, m2_num, m3_num, ...
            l1_num, l2_num, l3_num, ...
            g_num);
% Plot state vector and total energy
%subplot(2,1,1)
plot(t,Y)
title('Pendulum')
xlabel('t')

legend('th1', 'th1_d', 'th2', 'th2_d', 'th3', 'th3_d'); 

% ylabel('{\theta}(t), d{\theta}/dt(t)')
% subplot(2,1,2)
% 
% E_num = double(subs(E, ... 
%     {th1, th1_d, th2, th2_d, th3, th3_d, m1, m2, m3, l1, l2, l3, g}, ...
%     {Y(:,1),Y(:,2), ...
%     m_num,g_num,l_num}));
% 
% plot(t,E_num)
% xlabel('t')
% ylabel('E = T + V')
% % End of script
% 
