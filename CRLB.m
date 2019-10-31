% Cramer-Rao Lower Bound (位置、速度和角速度)

function filter_bound = CRLB (target_trajectory, sensor_pos, init_cov)

global Q R nx sensor_node;

Monte = size(target_trajectory,3);
num_steps = size(target_trajectory,2);
filter_bound = zeros(3,num_steps);

K_22 = eye(nx)/Q;

for run = 1:Monte
    
    filter_FIM = zeros(nx,nx,num_steps);
    
    pred_FIM = zeros(nx,nx,num_steps);
    
    for k = 1:num_steps
        
        if k == 1
            filter_FIM(:,:,k) = inv(init_cov);
        else
            % 计算先验CRLB
            Jf = jacobianState(target_trajectory(:,k-1,run));
            K_11 = Jf'/Q*Jf;
            K_12 = -Jf'/Q;
            
            pred_FIM(:,:,k) = K_22 - K_12'/(K_11 + filter_FIM(:,:,k-1))*K_12;
            
            % 计算后验CRLB
            meas_FIM = zeros(nx);
            for i = sensor_node
                Jh = jacobianObs(target_trajectory(:,k,run),sensor_pos(:,i));
                meas_FIM = meas_FIM + Jh'/R*Jh;
            end
            
            filter_FIM(:,:,k) = pred_FIM(:,:,k) + meas_FIM;
        end
        
        inverse = eye(nx)/filter_FIM(:,:,k); 
        %         filter_bound(k) = filter_bound(k) + sqrt(inverse(1,1) + inverse(3,3))/Monte;
        filter_bound(1,k) = filter_bound(1,k) + (inverse(1,1) + inverse(3,3));
        filter_bound(2,k) = filter_bound(2,k) + (inverse(2,2) + inverse(4,4));
        filter_bound(3,k) = filter_bound(3,k) + inverse(5,5);
    end
end

filter_bound = sqrt(filter_bound/Monte);

