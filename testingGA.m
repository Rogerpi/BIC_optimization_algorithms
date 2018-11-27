addpath('./benchmarks')
fprintf("Start test GA!\n")
close all

global initial_flag
global n_fun

viz = false;
% 24,23,22,21,20,19,18,17,16,15,10,9 have bounds -5, 5
%funcs = [12];%[9,10,15,16,17];
n_rep = 10;
funcs = [1,2,6,12,15];
outputs = [];
min_bound = [-100,-100,-100,-100,-5];
max_bound = [ 100, 100, 100, 100, 5];

dim = 8;
max_it = 700;
popsize = 300;
t_size = 5;
mut_rate = 0.5;

for i = 1:size(funcs,2)
    %Select Function
    initial_flag = 0;
    n_fun = funcs(i);
    fprintf("Using function n %d \n",n_fun);
    if viz
        %Plot function
        func_plot
    else
        figure(funcs(i))
    end

    %Create function handler. 
    f = @(y) -benchmark_func(y,n_fun);
    
    %initialize function
    benchmark_func(zeros(1,dim),n_fun);
    
    results = [];
    for r = 1:n_rep
       fprintf("Repetition n %d \n",r);
       tic
       if ~viz
           res = GA(popsize,t_size,mut_rate,f,max_it,dim,min_bound(i),max_bound(i)); 
           hold on,plot(1:max_it,res.progress),legend("exec. "+[1:r]);
       else
           res = GA(popsize,t_size,mut_rate,f,max_it,dim,-5,5,true,0.05); 
       end
       toc
       results = [results,res];
       pause(0.5)%Allow the plots to be shown
    end
    if viz
        hold on
        for r = 1:n_rep
            plot3([results(r).best_pose(2),results(r).best_pose(2)],[results(r).best_pose(1),results(r).best_pose(1)],[-results(r).best_fitness,-results(r).best_fitness-25]);
            scatter3(results(r).best_pose(2),results(r).best_pose(1),-results(r).best_fitness-25,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7]);
        end
    end
    outputs = [outputs;results];
    pause(0.2);
end


%Compute statistics

format shortG
m = [];
s = [];
b  = [];
for n = 1:size(outputs,1)
   b = [b,max([outputs(n,:).best_fitness])];
   m = [m,mean([outputs(n,:).best_fitness])];
   s = [s,std([outputs(n,:).best_fitness])];
end


