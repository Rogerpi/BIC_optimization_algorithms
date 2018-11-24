function GA(popsize,f)
    max_it = 5000;
    dimention = 2; %y = f(a,b);
    k_rand_pose = 10;
    t_size = 2;
    
    %Algorithm initialization
    
    hold on
    fprintf("Init Individuals...");
    
    population = {};
    population.pose = rand(dimention,popsize)*k_rand_pose;
    population.fitness = [];
    population.best_pose = [];
    population.best_fitness = -Inf;
    
    Q = zeros(dimention,popsize);
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
            population.pose(:,idx_a) = Mutate(Ca);
            population.pose(:,idx_b) = Mutate(Cb);
        end
        
           
        pause(0.05);
        delete(sc);
        delete(sc_best);
        
    end
  
end

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

function M = Mutate(C)
    M = C;
    for i=1:size(C)
        x = rand(2,1);
        if x(1) > 0.5
            M(i) = M(i) + x(2)*2-1;
        end
    end
end