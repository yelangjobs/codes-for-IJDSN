% fifth-degree cubature prediction

function [state_pred,cov_pred] = fifth_CKF_predict(state_est,state_cov)

    global Q fifth_cubature_points fifth_cubature_weights;
    
    num_points = size(fifth_cubature_points,2);
    sr_weights = sqrt(fifth_cubature_weights);
    
    points_sample = chol(state_cov,'lower')*fifth_cubature_points + repmat(state_est,1,num_points);
    points_pred = stateEq(points_sample);
    
    state_pred = sum(points_pred*diag(fifth_cubature_weights),2);
    
    pred_error = (points_pred - state_pred)*diag(sr_weights);
    cov_pred = pred_error*pred_error' + Q;   
end