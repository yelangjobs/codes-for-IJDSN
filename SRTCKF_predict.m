
function [state_pred,srcov_pred] = SRTCKF_predict(state_est,state_srcov)

    global Qsqrt third_cubature_points;
    
    num_points = size(third_cubature_points,2);
        
    points_sample = state_srcov*third_cubature_points + repmat(state_est,1,num_points);
    points_pred = stateEq(points_sample);
    
    state_pred = mean(points_pred,2);
    
    pred_error = (points_pred - repmat(state_pred,1,num_points))/sqrt(num_points);
    
    srcov_pred = Sroot([pred_error,Qsqrt]);  
end