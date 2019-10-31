% fifth-degree cubature prediction

function [state_pred,srcov_pred] = SRFCKF_predict(state_est,state_srcov)

    global Qsqrt fifth_cubature_points fifth_cubature_weights;
    
    num_points = size(fifth_cubature_points,2);
    sr_weights = sqrt(fifth_cubature_weights);
    
    points_sample = state_srcov*fifth_cubature_points + repmat(state_est,1,num_points);
    points_pred = stateEq(points_sample);
    
    weight_points_pred = points_pred*diag(fifth_cubature_weights);
    state_pred = sum(weight_points_pred,2);
    
    pred_error = (points_pred - repmat(state_pred,1,num_points))*diag(sr_weights);        
    srcov_pred = Sroot([pred_error,Qsqrt]);   
end