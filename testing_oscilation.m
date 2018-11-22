addpath('./benchmarks')

fprintf("Start test!\n")

close all

global initial_flag
global n_fun
initial_flag = 0;
n_fun = 3
%Choose fun_num

func_plot
fprintf("Using function n %n \n",n_fun);


f = @(y) -benchmark_func(y,n_fun);
%f = @(v) 100000 * gauss(v(:,1),v(:,2));
alpha = 1;
beta = 0.5;
gamma = 0.0;
delta = 0.0;
inf_ratio = 0.5;
epsilon = 1;
PSO_standard(100,alpha,beta,gamma,delta,epsilon,inf_ratio,f);


