% fifth-degree

function [target_est,target_srcov,time_elapse] = SRFCQIF_HC(sensor_pos,measurement,init_est,init_est_cov)

global nx nz L weight_metropolis sensor_node;


Ns = size(measurement,3);
num_steps = size(measurement,2);
init_est_srcov = zeros(nx,nx,Ns);
for i = 1:Ns
    init_est_srcov(:,:,i) = chol(init_est_cov(:,:,i),'lower');
end

target_est = zeros(nx,num_steps,Ns,L);
target_srcov = zeros(nx,nx,num_steps,Ns,L);

state_info_pred = zeros(nx,Ns);
state_info_srcov_pred = zeros(nx,nx,Ns);

meas_info = zeros(nx,Ns);
meas_info_srcov = zeros(nx,nz,Ns);

time_elapse = zeros(1,L);

for L_ = 1:L
    
    start = tic;
    
    for i = 1:Ns
        target_est(:,1,i,L_) = init_est(:,i);
        target_srcov(:,:,1,i,L_) = init_est_srcov(:,:,i);
    end
    
    for k = 2:num_steps
        
        for i = 1:Ns
            
            [state_pred,srcov_pred] = SRFCKF_predict(target_est(:,k-1,i,L_),target_srcov(:,:,k-1,i,L_));
            state_info_pred(:,i) = (srcov_pred*srcov_pred')\state_pred;
            state_info_srcov_pred(:,:,i) = eye(nx)/srcov_pred';
            
            if ismember(i,sensor_node)
                [measure_info,measure_info_srcov] = SRFCIF_contribute(state_pred,srcov_pred,measurement(:,k,i),sensor_pos(:,i));
            else
                measure_info = zeros(nx,1);
                measure_info_srcov = zeros(nx,nz);
            end
            
            meas_info(:,i) = measure_info;
            meas_info_srcov(:,:,i) = measure_info_srcov;
        end
        measinfo_srcov = meas_info_srcov;
        
        binary = zeros(Ns,1);
        binary(sensor_node) = 1;
        
        for iteration = 1:L_
            consensus_pred = zeros(nx,Ns);
            consensus_srcov_pred = zeros(nx,nx,Ns);
            srcov_pred_all = MatReshape(state_info_srcov_pred);
            
            consensus_meas = zeros(nx,Ns);
            consensus_srcov_meas = zeros(nx,nx,Ns);
            meas_info_srcov_all = MatReshape(measinfo_srcov);
            
            consensus_binary = zeros(Ns,1);
            
            for i = 1:Ns
                consensus_binary(i) = weight_metropolis(i,:)*binary;
                
                weight_state_info_pred = state_info_pred*diag(weight_metropolis(i,:));
                consensus_pred(:,i) = sum(weight_state_info_pred,2);
                
                weight_srcov_pred_all = srcov_pred_all*kron(diag(sqrt(weight_metropolis(i,:))),eye(nx));
                consensus_srcov_pred(:,:,i) = Sroot(weight_srcov_pred_all);
                
                weight_meas_info = meas_info*diag(weight_metropolis(i,:));
                consensus_meas(:,i) = sum(weight_meas_info,2);
                
                if iteration == 1
                    Si_uk = meas_info_srcov_all*kron(diag(sqrt(weight_metropolis(i,:))),eye(nz));
                    consensus_srcov_meas(:,:,i) = Sroot(Si_uk);
                else
                    Si_uk = meas_info_srcov_all*kron(diag(sqrt(weight_metropolis(i,:))),eye(nx));
                    consensus_srcov_meas(:,:,i) = Sroot(Si_uk);
                end
            end
            
            state_info_pred = consensus_pred;
            state_info_srcov_pred = consensus_srcov_pred;
            
            meas_info = consensus_meas;
            measinfo_srcov = consensus_srcov_meas;
            
            binary = consensus_binary;
        end
        
        for i = 1:Ns
            if abs(binary(i)) < eps
                binary(i) = 1;
            end
            Si_yk = Sroot([state_info_srcov_pred(:,:,i),measinfo_srcov(:,:,i)/sqrt(binary(i))]);
            target_srcov(:,:,k,i,L_) = eye(nx)/Si_yk';
            target_est(:,k,i,L_) =  (Si_yk*Si_yk')\(state_info_pred(:,i) + meas_info(:,i)/binary(i));
        end
    end
    time_elapse(1,L_) = toc(start);
end

