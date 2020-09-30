syms m1 l1 th1 th1_d;
syms m2 l2 th2 th2_d;
syms m3 l3 th3 th3_d;
syms g;

I1 = (1/3)*m1*l1^2;
I2 = (1/12)*m2*l2^2;
I3 = (1/12)*m3*l3^2;

x2_d = l1*th1_d*cos(th1) + 0.5*l2*(th1_d + th2_d)*cos(th1 + th2);

y2_d = -l1*th1_d*sin(th1) - 0.5*l2*(th1_d + th2_d)*sin(th1 + th2);

x3_d = l1*th1_d*cos(th1) + l2*(th1_d + th2_d)*cos(th1 + th2) ...
        + 0.5*l3*(th1_d + th2_d + th3_d)*cos(th1 + th2 + th3);

y3_d = -l1*th1_d*sin(th1) - l2*(th1_d + th2_d)*sin(th1 + th2) ...
        - 0.5*l3*(th1_d + th2_d + th3_d)*sin(th1 + th2 + th3);
    
v2_2 = x2_d^2 + y2_d^2;

v3_2 = x3_d^2 + y3_d^2;

T1 = 0.5*I1*th1_d^2;

T2 = 0.5*I2*(th1_d + th2_d)^2 + 0.5*m2*v2_2;

T3 = 0.5*I3*(th1_d + th2_d + th3_d)^2 + 0.5*m3*v3_2;

T   = T1 + T2 + T3;

U1 = 0.5*l1*cos(th1)*m1*g;

U2 = (l1*cos(th1) + 0.5*l2*cos(th1 + th2)) * m2*g;

U3 = (l1*cos(th1) + l2*cos(th1 + th2) + 0.5*l3*cos(th1 + th2 + th3)) * m3*g;

U   = U1 + U2 + U3;

L   = T - U;

X   = {th1 th1_d};

Q_i = {0}; Q_e = {0};
R   = 0;
par = {th2 th2_d th3 th3_d g m1 m2 m3 l1 l2 l3};

% Solve Lagrange equations and save DE as .m file
UF  = EulerLagrange(L,X,Q_i,Q_e,R,par,'m','PendulumModel_sys');

% Create Simulink block
SimBlock  = EulerLagrange(L,X,Q_i,Q_e,R,par,'s','PendulumModel_sys');