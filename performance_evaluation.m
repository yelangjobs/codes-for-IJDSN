 %% 性能分析比较
% Cramer-Rao lower bound
CRLB_filter = CRLB (target_trajectory, sensor_pos, init_cov);


% root mean square error (RMSE)
[pos_RMSE_SRTCQIF,vel_RMSE_SRTCQIF,turn_RMSE_SRTCQIF,error_ARMSE_SRTCQIF] = compute_RMSE(state_est_SRTCQIF_all,target_trajectory);
[pos_RMSE_SRFCQIF,vel_RMSE_SRFCQIF,turn_RMSE_SRFCQIF,error_ARMSE_SRFCQIF] = compute_RMSE(state_est_SRFCQIF_all,target_trajectory);

% normalize estimation error squared(NEES);
confidence_interval = chi2inv([0.025,0.975],nx*Monte)/Monte; % 95% confidence level

state_cov_SRTCQIF_all = srcov2cov(state_srcov_SRTCQIF_all);
nees_SRTCQIF = NEES(state_est_SRTCQIF_all,state_cov_SRTCQIF_all,target_trajectory);

state_cov_SRFCQIF_all = srcov2cov(state_srcov_SRFCQIF_all);
nees_SRFCQIF = NEES(state_est_SRFCQIF_all,state_cov_SRFCQIF_all,target_trajectory);

% averaged consensus estimation error(ACEE);
acee_SRTCQIF = ACEE(state_est_SRTCQIF_all);
acee_SRFCQIF = ACEE(state_est_SRFCQIF_all);

% computational cost
time_elapse_SRTCQIF = mean(SRTCQIF_time,2)/num_steps;
time_elapse_SRFCQIF = mean(SRFCQIF_time,2)/num_steps;



