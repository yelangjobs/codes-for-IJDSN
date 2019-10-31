% 量测信息贡献，单传感器情形；
function [meas_info,meas_info_srcov] = SRFCIF_contribute(state_pred,sr_cov_pred,measurement,sensor_pos)

    global Rsqrt fifth_cubature_points fifth_cubature_weights;
    
    num_points = size(fifth_cubature_points,2);
    sr_weights = sqrt(fifth_cubature_weights);
    points_sample = sr_cov_pred*fifth_cubature_points + repmat(state_pred,1,num_points);
    points_meas = mstEq(points_sample,sensor_pos);
    
    weight_points_meas = points_meas * diag(fifth_cubature_weights);
    meas_pred = sum(weight_points_meas,2);
    
    pred_error = (points_sample - repmat(state_pred,1,num_points))*diag(sr_weights);
    meas_error = (points_meas - repmat(meas_pred,1,num_points))*diag(sr_weights);
    cross_cov = pred_error*meas_error';
    cov_pred = sr_cov_pred*sr_cov_pred';
    pseu_meas_matrix = cross_cov'/cov_pred;
       
    Rs_hat = Sroot([meas_error - pseu_meas_matrix*pred_error, Rsqrt]);    
        
    meas_info = pseu_meas_matrix'/(Rs_hat*Rs_hat')*(measurement - meas_pred + pseu_meas_matrix*state_pred);
    meas_info_srcov = pseu_meas_matrix'/Rs_hat';
end