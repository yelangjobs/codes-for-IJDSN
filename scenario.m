
global T;
Monte = 100;  % no. of runs
Ns = 10; % no. of sensors
T = 1; % sampling interval
num_steps = 100; % total steps£»

%% dynamic model
global nx omg F Q Qsqrt;
nx = 5; % dim of state
omg = -3*pi/180; % initial turn rate
F = [1,sin(omg*T)/omg,0,(cos(omg*T) - 1)/omg,0;
    0,cos(omg*T),0,-sin(omg*T),0;
    0,(1- cos(omg*T))/omg,1,sin(omg*T)/omg,0;
    0,sin(omg*T),0,cos(omg*T),0;
    0,0,0,0,1];

M = [T^3/3,T^2/2;T^2/2,T];
q1 = 0.1; 
q2 = 1.75e-4; 
Q = blkdiag(q1*M,q1*M,q2*T); % covariance of process noise
Qsqrt = chol(Q,'lower');

%% measurement model
global nz R Rsqrt;
nz = 2; % dim of measurement
meanc = [0;0]; % mean of measurement noise
sigma_r = 10;
sigma_theta = sqrt(10)*10^-3;
R = diag([sigma_r^2,sigma_theta^2]); % measurement noise covariance
Rsqrt = chol(R,'lower');

%% sensor network
global E consensus_matrix weight_metropolis L sensor_node;
load('network.mat');
sensor_pos = posSensor; % position of sensors
sensor_node = SenNode; % label of sensor nodes
consensus_rate = 0.65/max(sum(E,1));
consensus_matrix = consensus_rate*E + diag(1- sum(E)*consensus_rate);
weight_metropolis = Metropolis(E);

L = 10; % total number of consensus iterations

%% cubature points
global fifth_cubature_points fifth_cubature_weights third_cubature_points third_cubature_weights;

[fifth_cubature_points, fifth_cubature_weights] = fifth_cubature(nx);
[third_cubature_points, third_cubature_weights] = third_cubature(nx);

%% generate true track
init_target = [1000,300,1000,0,omg]';
init_cov = diag([100,10,100,10,1e-4]);
target_trajectory = zeros(nx,num_steps,Monte);

for m = 1:Monte
    for k = 1:num_steps
        if k == 1
            target_trajectory(:,k,m) = init_target;
        else
            target_trajectory(:,k,m) = stateEq(target_trajectory(:,k-1,m)) + mvnrnd(zeros(1,nx),Q)';
        end
    end   
end

%% generate initial estimate
init_est = zeros(nx,Ns,Monte);
init_est_cov = zeros(nx,nx,Ns,Monte);

for m = 1:Monte
    for i = 1:Ns
        init_est(:,i,m) = mvnrnd(init_target',init_cov)';
        init_est_cov(:,:,i,m) = init_cov;
    end
end

%% generate measurements for sensor nodes
measurements = zeros(nz,num_steps,Ns,Monte);

for m = 1:Monte
    for i = sensor_node
        measurements(:,:,i,m) = mstEq(target_trajectory(:,:,m),sensor_pos(:,i)) + mvnrnd(zeros(1,nz),R,num_steps)';
    end
end