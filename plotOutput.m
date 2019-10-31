% 显示估计结果

%% show estimated results
L_ = 1;
m = 2;
figure;
hold on;
plot(mean(state_est_SRTCQIF_all(1,:,:,L_,m),3),mean(state_est_SRTCQIF_all(3,:,:,L_,m),3),'gs-.','LineWidth',1);
plot(mean(state_est_SRFCQIF_all(1,:,:,L_,m),3),mean(state_est_SRFCQIF_all(3,:,:,L_,m),3),'r*-.','LineWidth',1);
plot(target_trajectory(1,:,m),target_trajectory(3,:,m),'k-','LineWidth',1);
plot(target_trajectory(1,1,m),target_trajectory(3,1,m),'bs','LineWidth',1);
plot(target_trajectory(1,end,m),target_trajectory(3,end,m),'bo','LineWidth',1);
xlabel('m');ylabel('m');
legend('SRTCQIF','SRFCQIF','True trajectory');


%% show RMSE 
figure % pos RMSE;
hold on; 
plot((1:num_steps)*T,pos_RMSE_SRTCQIF(:,L_),'gs-.','LineWidth',1);
plot((1:num_steps)*T,pos_RMSE_SRFCQIF(:,L_),'r*-.','LineWidth',1);

plot((1:num_steps)*T,CRLB_filter(1,:),'k-','LineWidth',1);
xlabel('Time (s)'); ylabel('RMSE_{pos} (m)');
legend('SRTCQIF','SRFCQIF','CRLB');

figure; % velocity RMSE;
hold on; 
plot((1:num_steps)*T,vel_RMSE_SRTCQIF(:,L_),'gs-.','LineWidth',1);
plot((1:num_steps)*T,vel_RMSE_SRFCQIF(:,L_),'r*-.','LineWidth',1);

plot((1:num_steps)*T,CRLB_filter(2,:),'k-','LineWidth',1);
xlabel('Time (s)'); ylabel('RMSE_{vel} (m/s)');
legend('SRTCQIF','SRFCQIF','CRLB');

figure; % turn rate RMSE;
hold on; 
plot((1:num_steps)*T,turn_RMSE_SRTCQIF(:,L_),'gs-.','LineWidth',1);
plot((1:num_steps)*T,turn_RMSE_SRFCQIF(:,L_),'r*-.','LineWidth',1);

plot((1:num_steps)*T,CRLB_filter(3,:),'k-','LineWidth',1);
xlabel('Time (s)'); ylabel('RMSE_{ome} (rad/s)');
legend('SRTCQIF','SRFCQIF','CRLB');

%% ARMSE
figure; 
hold on;
plot(1:L,error_ARMSE_SRTCQIF(1,:),'gs-.','LineWidth',1);
plot(1:L,error_ARMSE_SRFCQIF(1,:),'r*-.','LineWidth',1);
plot(1:L,mean(CRLB_filter(1,:),2)*ones(1,L),'k-','LineWidth',1);
xlabel('Consensus Iterations');ylabel('ARMSE_{pos} (m)');
legend('SRTCQIF','SRFCQIF','CRLB');

%% show NEES
figure;
hold on;
% show NEES with fixed no. of iterations
sensor = 2; 
L_ = 1; 
plot((1:num_steps)*T,nees_SRTCQIF(:,sensor,L_),'gs-.','LineWidth',1);
plot((1:num_steps)*T,nees_SRFCQIF(:,sensor,L_),'r*-.','LineWidth',1);

plot((1:num_steps)*T,confidence_interval(1)*ones(1,num_steps),'k--','LineWidth',1);
plot((1:num_steps)*T,confidence_interval(2)*ones(1,num_steps),'k--','LineWidth',1);

xlabel('Time (s)');ylabel('NEES');
legend('SRTCQIF','SRFCQIF');
 
%% show ACEE
figure
hold on;
L_ = 10; % show ACEE with fixed no. of consensus iterations
plot((1:num_steps)*T,acee_SRTCQIF(:,L_),'gs-.','LineWidth',1);
plot((1:num_steps)*T,acee_SRFCQIF(:,L_),'r*-.','LineWidth',1);

xlabel('Time (s)'); ylabel('ACEE');
legend('SRTCQIF','SRFCQIF');

%% show ACEE with different no. of consensus iterations 
figure
hold on;
plot(1:L,mean(acee_SRTCQIF),'gs-.','LineWidth',1);
plot(1:L,mean(acee_SRFCQIF),'r*-.','LineWidth',1);
xlabel('Time (s)'); ylabel('ACEE');
legend('SRTCQIF','SRFCQIF');

%% show computational cost
figure; 
hold on
plot(1:L,time_elapse_SRTCQIF,'gs-.','LineWidth',1);
plot(1:L,time_elapse_SRFCQIF,'r*-.','LineWidth',1);

xlabel('Consensus Iterations'); ylabel('Computational Time (s)');
legend('SRTCQIF','SRFCQIF');

