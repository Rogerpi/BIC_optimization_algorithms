addpath('./benchmarks')
fprintf("Start test PSO!\n")

close all

global initial_flag
global n_fun

% 24,23,22,21,20,19,18,17,16,15,10,9 have bounds -5, 5
funcs = [2,6,12,14,20];
funcs = [1,2,6,12,15];
min_bound = [-100,-100,-100,-100,-5];
max_bound = [ 100, 100, 100, 100,5];
n_rep = 10;

viz = false;
outputs = [];
%0.1,1.9,1.4,0.7
%0.1,1.3,2,0.7
%0.1,1.5,2.1,0.4
alpha = 0.1;
beta = 1.9;
gamma = 1.4;
delta = 0.7;
inf_ratio = 0.4;
epsilon = 1;
swarmsize = 300;
dim = 8;
max_it = 700;

for i = 1:size(funcs,2)
    
    %Select Function
    initial_flag = 0;
    n_fun = funcs(i);
    fprintf("Using function n %d ",n_fun);
    if viz
        %Plot function
        dim = 2;
        func_plot
    else
        figure(funcs(i)+100), %Don't collide with GA plots
    end
    %Create function handler. 
    f = @(y) -benchmark_func(y,n_fun);
    
    %initialize function
    benchmark_func(zeros(1,dim),n_fun);
    
    results = [];
    for r = 1:n_rep
       fprintf("Repetition n %d ",r);
       tic
       if ~viz
           res = PSO(swarmsize,alpha,beta,gamma,delta,epsilon,inf_ratio,f,max_it,dim,min_bound(i),max_bound(i));
           hold on,plot(1:max_it,res.progress),legend("exec. "+[1:r]);
       else
           res = PSO(swarmsize,alpha,beta,gamma,delta,epsilon,inf_ratio,f,max_it,dim,min_bound(i),max_bound(i),true);
       end
       fprintf(" fitness: %f ",res.best_fitness)
       toc;
       results = [results,res];
       pause(0.5);%Allow plot to be shown
    end
    if viz
        hold on
        for r = 1:n_rep
            plot3([results(r).best_pose(2),results(r).best_pose(2)],[results(r).best_pose(1),results(r).best_pose(1)],[-results(r).best_fitness,-results(r).best_fitness-10]);
            scatter3(results(r).best_pose(2),results(r).best_pose(1),-results(r).best_fitness-10,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7]);
        end
    end
    outputs = [outputs;results];
end

%Compute statistics

format shortG
m = [];
s = [];
b = [];
for n = 1:size(outputs,1)
   b = [b,max([outputs(n,:).best_fitness])];
   m = [m,mean([outputs(n,:).best_fitness])];
   s = [s,std([outputs(n,:).best_fitness])];
end



