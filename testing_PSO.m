addpath('./benchmarks')
fprintf("Start test PSO!\n")
close all

global initial_flag
global n_fun

% 24,23,22,21,20,19,18,17,16,15,10,9 have bounds -5, 5
funcs = [9,10,15,16,17];
n_rep = 5;

outputs = [];

alpha = 0.3;
beta = 0.1;
gamma = 0.25;
delta = 0.5;
inf_ratio = 0.5;
epsilon = 1;
swarmsize = 400;
dim = 2;

for fun = funcs
    fprintf("Using function n %d \n",n_fun);
    %Select Function
    initial_flag = 0;
    n_fun = fun;
    %Plot function
    func_plot
    
    %Create function handler. 
    f = @(y) -benchmark_func(y,n_fun);
    
    results = [];
    for r = 1:n_rep
       fprintf("Repetition n %d \n",r);
       tic
       res = PSO(100,alpha,beta,gamma,delta,epsilon,inf_ratio,f,swarmsize,dim,[-5,-5],[5,5],true);
       toc
       results = [results,res];
    end
    outputs = [outputs;results];
end

%f = @(v) 100000 * gauss(v(:,1),v(:,2));



