x_e_goal = 1;   % Meter
z_e_goal = 1.3; % Meter
T_goal   = 2; % Seconds
Ts       = 0.1; % Seconds

z_start  = 1.465; % Meter
x_start  = 0.03; % Meter

N = 10;

traj_ref = zeros(N, 3); 

for i=1:N 
    
    traj_ref(i,1) = i*T_goal/N;
    traj_ref(i,2) = (x_e_goal-x_start)*i/N + x_start;
    traj_ref(i,3) = (z_e_goal-z_start)*i/N + z_start;
    
end