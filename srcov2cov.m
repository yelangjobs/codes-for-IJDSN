function cov_est = srcov2cov(srcov_est)
% srcovÎªn_x¡Án_x¡Ánum_steps¡ÁNs¡ÁL¡ÁMonte

num_steps = size(srcov_est,3);
Ns = size(srcov_est,4); % number of sensors
L = size(srcov_est,5);
Monte = size(srcov_est,6);
cov_est = zeros(size(srcov_est));

for m = 1:Monte
    for L_ = 1:L
        for i = 1:Ns           
            for k = 1:num_steps
                cov_est(:,:,k,i,L_,m) = srcov_est(:,:,k,i,L_,m)*srcov_est(:,:,k,i,L_,m)';
            end            
        end        
    end
end
