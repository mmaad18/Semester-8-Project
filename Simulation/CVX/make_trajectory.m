x_e_goal = 1;   % Meter
z_e_goal = -0.1650; % Meter
T_goal   = 5; % Seconds
Ts       = 0.1; % Seconds

%x_start  = 0.025; % Meter
%z_start  = 1.465; % Meter

x_start  = 0; % Meter
z_start  = 0; % Meter

M = T_goal/Ts;

traj_ref = zeros(M+M, 3); 

for i=1:M
    
    traj_ref(i,1) = i*T_goal/M;
    traj_ref(i,2) = (x_e_goal-x_start)*i/M + x_start;
    traj_ref(i,3) = (z_e_goal-z_start)*i/M + z_start;
    
end

for i=M:M+M
    
    traj_ref(i,1) = i*T_goal/M;
    traj_ref(i,2) = x_e_goal;
    traj_ref(i,3) = z_e_goal;
    
end

