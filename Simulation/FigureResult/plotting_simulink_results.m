%% End effector position plot

figure('Name', 'x_z_end_effector')
plot(x_z_out(:,1),x_z_out(:,2))
set(gca,'FontSize',20)
xlabel('X [m]', 'fontsize', 20)
ylabel('Z [m]', 'fontsize', 20)
%legend('Input X=1m  Z=1.3m')
title('End effector movement', 'fontsize', 25)


%% X Translation plot

figure('Name', 'x_translation')
plot(x_translation(:,1),x_translation(:,2))
set(gca,'FontSize',20)
xlabel('Time [s]', 'fontsize', 20)
ylabel('X [m]', 'fontsize', 20)
%legend('Translation in X of ball')
title('Translation of Kugle', 'fontsize', 25)



%% Theta Angles in subplots Approach 2

figure('Name', 'Theta_angles')
h1 = subplot(3,1,1);
plot(Theta_angles(:,1),Theta_angles(:,2)*180/pi)
%legend('Theta 1')
%ylabel('degrees', 'fontsize', 20)
set(gca,'FontSize',20)
title('Theta 1', 'fontsize', 15)

h2 = subplot(3,1,2);
plot(Theta_angles(:,1),Theta_angles(:,4)*180/pi)
%legend('Theta 2')
set(gca,'FontSize',20)
ylabel('Joint Angle [degrees]', 'fontsize', 20)
title('Theta 2', 'fontsize', 15)

h3 = subplot(3,1,3);
plot(Theta_angles(:,1),Theta_angles(:,6)*180/pi)
%legend('Theta 3')

xlabel('Time [s]', 'fontsize', 20)
set(gca,'FontSize',20)
%ylabel('degrees', 'fontsize', 20)
title('Theta 3', 'fontsize', 15)

sgtitle('Joint Angles', 'fontsize', 25)



%% Theta Angles in subplots Approach 1

figure('Name', 'Theta_angles')
h1 = subplot(3,1,1);
plot(Theta_angles(:,1),Theta_angles(:,2))
set(gca,'FontSize',20)
%legend('Theta 1')
%ylabel('degrees', 'fontsize', 20)
title('Theta 1', 'fontsize', 15)

h2 = subplot(3,1,2);
plot(Theta_angles(:,1),Theta_angles(:,3))
%legend('Theta 2')
set(gca,'FontSize',20)

ylabel('Joint Angle [degrees]', 'fontsize', 20)
title('Theta 2', 'fontsize', 15)

h3 = subplot(3,1,3);
plot(Theta_angles(:,1),Theta_angles(:,4))
%legend('Theta 3')
set(gca,'FontSize',20)
xlabel('Time [s]', 'fontsize', 20)
%ylabel('degrees', 'fontsize', 20)
title('Theta 3', 'fontsize', 15)

sgtitle('Joint Angles', 'fontsize', 25)



%% X Translation plot
figure('Name', 'CoMx')
plot(CoMx(:,1),CoMx(:,2), 'LineWidth', 1)
axis([0 3 -1 1])
xlabel('Time [s]', 'fontsize', 20)
ylabel('X [m]', 'fontsize', 20)
legend('Center of Mass Displacement')
title('Center of Mass Displacement in X', 'fontsize', 25)



%% X Translation plot Approach 1 CoM proof
figure('Name', 'Translation')
plot(x_trans_out(:,1),x_trans_out(:,2), 'LineWidth', 1)
set(gca,'FontSize',20)

xlabel('Time [s]', 'fontsize', 20)
ylabel('X [m]', 'fontsize', 20)
%legend('Center of Mass Displacement')
title('Translation of Kugle with no Theta1 regulation', 'fontsize', 25)
