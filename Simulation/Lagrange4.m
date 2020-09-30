syms m0 x x_d;
syms m1 l1 th1 th1_d;
syms m2 l2 th2 th2_d;
syms m3 l3 th3 th3_d;
syms g;

% Inertias
I1 = (1/3)*m1*l1^2;
I2 = (1/12)*m2*l2^2;
I3 = (1/12)*m3*l3^2;

% Position and velocities of joint 1
%x1   = x + cos(th1)*l1;
%z1   = sin(th1)*l1;
x1_d = (x_d - l1*th1_d*cos(th1));
z1_d = (-l1*th1_d*sin(th1));

v1   = x1_d^2 + z1_d^2;


% Position and velocities of joint 2
%x2   = 
x2_d = l1*th1_d*cos(th1) + 0.5*l2*(th1_d + th2_d)*cos(th1 + th2);
z2_d = -l1*th1_d*sin(th1) - 0.5*l2*(th1_d + th2_d)*sin(th1 + th2);

v2_2 = x2_d^2 + z2_d^2;


% Position and velocities of joint 3
x3_d = l1*th1_d*cos(th1) + l2*(th1_d + th2_d)*cos(th1 + th2) ...
        + 0.5*l3*(th1_d + th2_d + th3_d)*cos(th1 + th2 + th3);
z3_d = -l1*th1_d*sin(th1) - l2*(th1_d + th2_d)*sin(th1 + th2) ...
        - 0.5*l3*(th1_d + th2_d + th3_d)*sin(th1 + th2 + th3);

v3_2 = x3_d^2 + z3_d^2;

T0 = 0.5*m0*x_d^2;

T1 = 0.5*I1*th1_d^2 + 0.5*m1*x_d^2;

T2 = 0.5*I2*(th1_d + th2_d)^2 + 0.5*m2*v2_2 + 0.5*m2*x_d^2;

T3 = 0.5*I3*(th1_d + th2_d + th3_d)^2 + 0.5*m3*v3_2 + 0.5*m3*x_d^2;

T  = T0 + T1 + T2 + T3;

U1 = 0.5*l1*cos(th1)*m1*g;

U2 = (l1*cos(th1) + 0.5*l2*cos(th1 + th2)) * m2*g;

U3 = (l1*cos(th1) + l2*cos(th1 + th2) + 0.5*l3*cos(th1 + th2 + th3)) * m3*g;

U   = U1 + U2 + U3;

L   = T - U;

X   = {th1 th1_d th2 th2_d th3 th3_d};

Q_i = {0 0 0}; Q_e = {0 0 0};
R   = 0;
par = {g m0 m1 m2 m3 l1 l2 l3 x_d};

% Solve Lagrange equations and save DE as .m file
UF  = EulerLagrange(L,X,Q_i,Q_e,R,par,'m','Kugle_sys7');

% Create Simulink block
SimBlock  = EulerLagrange(L,X,Q_i,Q_e,R,par,'s','Kugle_sys7');