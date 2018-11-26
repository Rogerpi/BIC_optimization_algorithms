
%% Call function, to run the GA algorith with or without visualization without losing performance
function population = GA(popsize,t_size,mut_fact,f,max_it,dimention,min_range,max_range,varargin)
    if nargin == 8 || ~varargin{1}
        population = GA_core(popsize,t_size,mut_fact,f,max_it,dimention,min_range,max_range);
    else     
        if dimention > 2
            disp("Visualization only in 2D functions")
            return
        else
            if nargin == 9
                step = 0.05;
            else
                step = varargin{2};
            end
            population = GA_viz(popsize,t_size,mut_fact,f,max_it,dimention,min_range,max_range,step);
        end 
    end
end

%% GA algorithm, no visualization
function population = GA_core(popsize,t_size,mut_fact,f,max_it,dimention,min_range,max_range)
    %Algorithm initialization

    %To spread the population
    range = max_range - min_range;
    center = min_range + range/2;
    
    population = {};
    population.pose = rand(dimention,popsize).*range'*2 - range' + center'; %TODO: initialize

    population.fitness = [];
    population.best_pose = [];
    population.best_fitness = -Inf;

    for it=1:max_it
        population.fitness = f(population.pose')';
        for p = 1:popsize 
            if population.fitness(p) > population.best_fitness
                population.best_fitness = population.fitness(p);
                population.best_pose = population.pose(:,p);
            end
        end
        for p = 1:2:round(popsize)
            [Pa,idx_a] = TournamentSelection(population,t_size);
            [Pb,idx_b] = TournamentSelection(population,t_size);
            [Ca,Cb] = Crossover(Pa,Pb);
            population.pose(:,idx_a) = Mutate(Ca,mut_fact);
            population.pose(:,idx_b) = Mutate(Cb,mut_fact);
        end
    end

end

%% Same GA Algorithm but plotting (2D input only)
function population = GA_viz(popsize,t_size,mut_fact,f,max_it,dimention,min_range,max_range,step)
    %Algorithm initialization
    
    hold on
    fprintf("Init Individuals...");
    
    %To spread the population
    range = max_range - min_range;
    center = min_range + range/2;
    
    population = {};
    population.pose = rand(dimention,popsize).*range'*2 - range' + center'; %TODO: initialize

    population.fitness = [];
    population.best_pose = [];
    population.best_fitness = -Inf;
    
    fprintf("Done!\n");
    for it=1:max_it
        fprintf("Iteration: %d \n",it);
        population.fitness = f(population.pose')';
        for p = 1:popsize 
            if population.fitness(p) > population.best_fitness
                population.best_fitness = population.fitness(p);
                population.best_pose = population.pose(:,p);
                fprintf("Best found \n");
            end
        end
        sc_best = scatter3(population.best_pose(2),population.best_pose(1),-population.best_fitness,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7]);
        sc = scatter3(population.pose(2,:),population.pose(1,:),-population.fitness);

        for p = 1:2:round(popsize)
            [Pa,idx_a] = TournamentSelection(population,t_size);
            [Pb,idx_b] = TournamentSelection(population,t_size);
            [Ca,Cb] = Crossover(Pa,Pb);
            population.pose(:,idx_a) = Mutate(Ca,mut_fact);
            population.pose(:,idx_b) = Mutate(Cb,mut_fact);
        end
     
        pause(step);
        delete(sc);
        delete(sc_best);
        
    end

end

%% Tournament Selection algorithm
function [Ps,idx] = TournamentSelection(population,t)
    %Tournament Selection
    len = size(population.pose,2);
    sel = randsample(len,t,true); % select randomly with replacement
    idx = sel(1);
    for i=2:t
        if population.fitness(sel(i)) > population.fitness(idx)
           idx = sel(i); 
        end
    end
    Ps = population.pose(:,idx);
    
end

function [Ca,Cb] = Crossover(Pa,Pb)
    % Pa and Pb are single column vectors
    len = size(Pa,1);
    Ca = Pa;
    Cb = Pb;
    c = randsample(len,1);
    d = randsample(len,1);
    if c > d
        [d,c] = deal(c,d); %swap data
    end
    if c ~= d
        [Ca(c:d-1),Cb(c:d-1)] = deal(Cb(c:d-1),Ca(c:d-1));
    end   
end

%% Mutate algorithm. Randomly adds noise 
% TODO: dinamically decide the amount of noise
function M = Mutate(C,mut_fact)
    M = C;
    for i=1:size(C)
        x = rand(2,1);
        if x(1) > mut_fact
            M(i) = M(i) + x(2)*2-1;
        end
    end
end