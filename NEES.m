
function filter_nees = NEES(target_est,target_cov,true_state)
% compute the normalized estimation error squared

num_steps = size(target_est,2);
Ns = size(target_est,3);
L = size(target_est,4);
Monte = size(target_est,5);

filter_nees = zeros(num_steps,Ns,L);

for L_ = 1:L
    for m = 1:Monte
        for i = 1:Ns
            for k = 1:num_steps
                est_error = true_state(:,k,m) - target_est(:,k,i,L_,m);
                filter_nees(k,i,L_) = est_error'/target_cov(:,:,k,i,L_,m)*est_error;
            end
        end
    end
end



