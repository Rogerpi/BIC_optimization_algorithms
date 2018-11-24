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
            Pa = selectWithReplacement(people);
            Pb = selectWithReplacement(people);
            [Ca,Cb] = Crossover(Pa,Pb);
            Q(:,p) = Ca;
            Q(:,p+1) = Cb;
        end
        
           
        pause(0.2);
        delete(sc);
        
    end
  
end

function Ps = selectwithReplacement(people,t)
%Tournament Selection
len = size(people.pose,2);
sel = randsample(len,t,true); % select randomly with replacement
best_idx = sel(1);
for i=2:len
    if people.fitness(sel(i)) > people.fitness(best_idx)
       best_idx = sel(i); 
    end
end

Ps = people.pose(:,best_idx);

end

function [Ca,Cb] = Crosover(Pa,Pb)

end
