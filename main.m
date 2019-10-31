% Ö÷³ÌÐò

clear;
clc;
close all;

% input
run scenario;   

%% output 
% estimated state
state_est_SRFCQIF_all = zeros(nx,num_steps,Ns,L,Monte);
state_srcov_SRFCQIF_all = zeros(nx,nx,num_steps,Ns,L,Monte);

state_est_SRTCQIF_all = zeros(nx,num_steps,Ns,L,Monte);
state_srcov_SRTCQIF_all = zeros(nx,nx,num_steps,Ns,L,Monte);

% time elapsed;
SRFCQIF_time = zeros(L,Monte);
SRTCQIF_time = zeros(L,Monte);

%% Monte Carlo run
for m = 1:Monte
    
    fprintf('MC Run in Process = %d\n',m); 
    % SRTCQIF-HC
    [state_est_SRTCQIF_all(:,:,:,:,m),state_srcov_SRTCQIF_all(:,:,:,:,:,m),SRTCQIF_time(:,m)] = SRTCQIF_HC(sensor_pos,measurements(:,:,:,m),init_est(:,:,m),init_est_cov(:,:,:,m));
    % SRFCQIF-HC
    [state_est_SRFCQIF_all(:,:,:,:,m),state_srcov_SRFCQIF_all(:,:,:,:,:,m),SRFCQIF_time(:,m)] = SRFCQIF_HC(sensor_pos,measurements(:,:,:,m),init_est(:,:,m),init_est_cov(:,:,:,m));
       
end

%% performance comparison
run performance_evaluation;

% show results
run plotOutput;


