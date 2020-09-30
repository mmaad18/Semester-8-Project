

clear all
close all
clc

% cvx 

L = 10; % Window size of the mpc proplem (Control horizon = Prediction horizon)
%M = 200; % The duration of the control process
Ts = 0.1; % Time step (seconds)

make_trajectory;

M = size(traj_ref,1);

x_reference = traj_ref(:,2);
z_reference = traj_ref(:,3);

load('linearized_plant_2.mat')

%[Hu,H0] = ImpulseResponse(L*Ts,plant.A,plant.B,plant.C, []);

% constraints
t1_min = -0.05555*pi;
t1_max = 0.05555*pi;
t2_min = -0.316*pi;
t2_max = 0.5556*pi;
%t3_min = pi/2; % remember to minus t2 in the constraints
t3_min = -0.73888*pi;
t3_max = 0.73888*pi;

dt1_min = -0.01111*pi;
dt1_max = 0.01111*pi;
dt2_min = -0.05555*pi;
dt2_max = 0.05555*pi;
dt3_min = -0.05555*pi;
dt3_max = 0.05555*pi;


t1_sys = zeros(M-L+1,1);
dt1_sys = zeros(M-L+1,1);
t2_sys = zeros(M-L+1,1);
dt2_sys = zeros(M-L+1,1);
t3_sys = zeros(M-L+1,1);
dt3_sys = zeros(M-L+1,1);

%x_sys = zeros(M-L+2,1);
%z_sys = zeros(M-L+2,1);

y_sys = zeros(M-L,2);

state_sys = zeros(M-L+2,6);



% initial output point for the end effector

% y_sys(1,1) = 0.025;
% y_sys(1,2) = 1.465;
y_sys(1,1) = 0;
y_sys(1,2) = 0;

% initial state values
t2_sys(1) = -0.3166*pi;
t3_sys(1) = 0.73888*pi;
%t2_sys(1) = 0.3166*180;
%t3_sys(1) = 0.73888*180;

%state_sys(1,:) = [0 0 t2_sys(1) 0 t3_sys(1) 0];
state_sys(1,:) = [0 0 0 0 0 0];

R = [0 0 0; 0 0 0; 0 0 0];
Q = [1 0; 0 1];

%%

for k = 1:M-L
%for k = 1:20
    
    cvx_begin % The begining of the optimization problem
    
    %variables t1(L,1) dt1(L,1) t2(L,1) dt2(L,1) t3(L,1) dt3(L,1) y(L,2)
    variables state(L,6) y(L,2) u(L,3)
    
    minimize(sum((x_reference(k:k+L-1) - y(:,1)).^2)*Q(1,1) + sum((z_reference(k:k+L-1) - y(:,2)).^2)*Q(2,2) + sum(abs(u(:,1)*R(1,1)))+sum(abs(u(:,2)*R(2,2)))+sum(abs(u(:,3)*R(3,3))))
    %minimize(norm(u(1,:))*R*norm(u(1,:)'))
    
    subject to
    
    % prediction of the state
    state == [state_sys(k,:); (plant.A * state(1:end-1,:)')' + (plant.B * [u(1:end-1,1) u(1:end-1,2) u(1:end-1,3)]')'];
    
    % prediction of the output
    y == (plant.C * state(1:end,:)')';
    


    %u(1:end,1) >= 0.005*pi;  
    
    u(1:end,1) >= t1_min;
    u(1:end,1) <= t1_max;
    u(1:end,2) >= t2_min;
    u(1:end,2) <= t2_max;
    u(1:end,3) >= t3_min;
    u(1:end,3) <= t3_max;
    
    state(1:end,1) >= t1_min;
    state(1:end,1) <= t1_max;
    state(1:end,3) >= t2_min;
    state(1:end,3) <= t2_max;
    state(1:end,5) >= t3_min;
    state(1:end,5) <= t3_max;
    
    state(1:end,2) >= dt1_min;
    state(1:end,2) <= dt1_max;
    state(1:end,4) >= dt2_min;
    state(1:end,4) <= dt2_max;
    state(1:end,6) >= dt3_min;
    state(1:end,6) <= dt3_max;
    
cvx_end

%y_sys(k+1,:) = (H0*[t1(1) dt1(1) t2(1) dt2(1) t3(1) dt3(1)]')';
state_sys(k+1,:) = plant.A * state_sys(k,:)' + plant.B * [u(1,1) u(1,2) u(1,3)]';
%y_sys(k+1,:) = plant.C * state_sys(k+1,:)';
y_sys(k+1,:) = plant.C * state_sys(k,:)';

end

%%

figure
hold on
plot(y_sys(:,1),y_sys(:,2))
plot(x_reference,z_reference)
title('end effector')
legend('Ysys', 'reference')
ylabel('z')
xlabel('x')

figure
hold on
plot(state_sys(:,1)*180/pi)
plot(state_sys(:,3)*180/pi)
plot(state_sys(:,5)*180/pi)
title('theta1,2,3')
legend('theta1', 'theta2', 'theta3')
ylabel('angle in degrees')
xlabel('time')


%%


figure('Name', 'x_z_end_effector')
hold on
plot(y_sys(:,1),y_sys(:,2))
plot(x_reference,z_reference)
xlabel('X [m]', 'fontsize', 20)
ylabel('Z [m]', 'fontsize', 20)
legend('plant output', 'reference')
title('End effector movement', 'fontsize', 25)

figure('Name', 'Theta_angles')
h1 = subplot(3,1,1);
plot(traj_ref(1:92,1),state_sys(:,1)*180/pi)
%legend('Theta 1')
%ylabel('degrees', 'fontsize', 20)
title('Theta 1', 'fontsize', 15)

h2 = subplot(3,1,2);
plot(traj_ref(1:92,1),state_sys(:,3)*180/pi)
%legend('Theta 2')
ylabel('Joint Angle [degrees]', 'fontsize', 20)
title('Theta 2', 'fontsize', 15)

h3 = subplot(3,1,3);
plot(traj_ref(1:92,1),state_sys(:,5)*180/pi)
%legend('Theta 3')
xlabel('Time [s]', 'fontsize', 20)
%ylabel('degrees', 'fontsize', 20)
title('Theta 3', 'fontsize', 15)

sgtitle('Joint Angles', 'fontsize', 25)
