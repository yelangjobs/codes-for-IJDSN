function [pos_rmse,vel_rmse,turn_rmse,error_armse] = compute_RMSE(estimate,trajectory)

Ns = size(estimate,3);
L = size(estimate,4);
trajectory_match = permute(repmat(trajectory,[1,1,1,Ns,L]),[1,2,4,5,3]);
error_estimate = estimate - trajectory_match;
pos_mse = mean(mean(sum(error_estimate([1,3],:,:,:,:).^2,1),3),5);
vel_mse = mean(mean(sum(error_estimate([2,4],:,:,:,:).^2,1),3),5);
turn_mse =mean(mean(error_estimate(5,:,:,:,:).^2,3),5); 

pos_mse = squeeze(pos_mse);
vel_mse = squeeze(vel_mse);
turn_mse = squeeze(turn_mse);

pos_rmse = sqrt(pos_mse);
vel_rmse = sqrt(vel_mse);
turn_rmse = sqrt(turn_mse);

error_armse = sqrt([mean(pos_mse,1);mean(vel_mse,1);mean(turn_mse,1)]);
