addpath('./benchmarks')

fprintf("Start test GA!\n")

close all

global initial_flag
global n_fun
initial_flag = 0;
n_fun = 10;
%Choose fun_num

func_plot
fprintf("Using function n %d \n",n_fun);

f = @(y) -benchmark_func(y,n_fun);
%f = @(v) 100000 * gauss(v(:,1),v(:,2));
GA(100,2,0.3,f,4000,2,[-5,-5],[5,5]);


