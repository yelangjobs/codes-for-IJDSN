function filter_acee = ACEE(target_est)
% compute the average consensus estimate error

num_steps = size(target_est,2);
Ns = size(target_est,3); % number of sensors
L = size(target_est,4);
Monte = size(target_est,5);

filter_acee = zeros(num_steps,L);

for L_ = 1:L
    for m = 1:Monte
        for k = 1:num_steps
            for i = 1:Ns-1
                for i_ = (i+1):Ns
                    filter_acee(k,L_) = filter_acee(k,L_) + norm(target_est(:,k,i_,L_,Monte) - target_est(:,k,i,L_,Monte));
                end
            end            
        end        
    end
    filter_acee(:,L_) = 2*filter_acee(:,L_)/(Ns*(Ns - 1))/Monte;
end

