function GA(popsize,f)
    max_it = 400;
    dimention = 2; %y = f(a,b);
    k_rand_pose = 100;
    
    %Algorithm initialization
    
    hold on
    fprintf("Init Individuals...");
    
    people = {};
    people.pose = rand(dimention,popsize)*k_rand_pose;
    people.fitness = [];
    people.best_pose = [];
    people.best_fitness = -Inf;
    
    Q = zeros(dimention,popsize);
    fprintf("Done!\n");
    for it=1:max_it
        people.fitness = f(people.pose')';
        sc = scatter3(people.pose(2,:),people.pose(1,:),-fitness);
        for p = 1:popsize 
            if people.fitness(p) > people.best_fitness
                people.best_fitness = people.fitness(p);
                people.best_pose = people.pose(p);
            end

        end
        for p = 1:2:round(popsize)
            [Pa,idx_a] = TournamentSelection(people);
            [Pb,idx_b] = TournamentSelection(people);
            [Ca,Cb] = Crossover(Pa,Pb);
            Q(:,idx_a) = Mutate(Ca);
            Q(:,idx_b) = Mutate(Cb);
        end
        
           
        pause(0.2);
        delete(sc);
        
    end
  
end

function [Ps,idx] = TournamentSelection(people,t)
    %Tournament Selection
    len = size(people.pose,2);
    sel = randsample(len,t,true); % select randomly with replacement
    idx = sel(1);
    for i=2:len
        if people.fitness(sel(i)) > people.fitness(idx)
           idx = sel(i); 
        end
    end
    Ps = people.pose(:,idx);
    
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
    [M,~] = Crossover(C,C);
end