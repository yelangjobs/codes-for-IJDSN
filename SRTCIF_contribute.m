
function [meas_info,meas_info_srcov] = SRTCIF_contribute(state_pred,srcov_pred,measurement,sensor_pos)

    global Rsqrt third_cubature_points;
    
    num_points = size(third_cubature_points,2);
    points_sample = srcov_pred*third_cubature_points + repmat(state_pred,1,num_points);
    points_meas = mstEq(points_sample,sensor_pos);
    
    meas_pred = mean(points_meas,2);
    
    pred_error = (points_sample - repmat(state_pred,1,num_points))/sqrt(num_points);
    meas_error = (points_meas - repmat(meas_pred,1,num_points))/sqrt(num_points);
    cross_cov = pred_error*meas_error';
    cov_pred = srcov_pred*srcov_pred';
    pseudo_meas_matrix = cross_cov'/cov_pred;
       
    Rs_hat = Sroot([meas_error - pseudo_meas_matrix*pred_error, Rsqrt]);    
        
    meas_info = pseudo_meas_matrix'/(Rs_hat*Rs_hat')*(measurement - meas_pred + pseudo_meas_matrix*state_pred);
    meas_info_srcov = pseudo_meas_matrix'/Rs_hat';
end