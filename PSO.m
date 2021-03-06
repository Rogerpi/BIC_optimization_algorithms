
%% Call function, to run the PSO algorith with or without visualization without losing performance
function swarm = PSO(swarmsize,alpha,beta,gamma,delta,epsilon,inf_ratio,f,max_it,dimention,min_range,max_range,varargin)
    if nargin == 12 || ~varargin{1}
       swarm = PSO_standard(swarmsize,alpha,beta,gamma,delta,epsilon,inf_ratio,f,max_it,dimention,min_range,max_range);
    else     
        if dimention > 2
            disp("Visualization only in 2D functions")
            return
        else
            if nargin == 13
                step = 0.05;
            else
                step = varargin{2};
            end
            swarm = PSO_standard_viz(swarmsize,alpha,beta,gamma,delta,epsilon,inf_ratio,f,max_it,dimention,min_range,max_range,step);
        end 
    end
end

%% PSO Standard algorithm, no visualization
function swarm = PSO_standard(swarmsize,alpha,beta,gamma,delta,epsilon,inf_ratio,f,max_it,dimention,min_range,max_range)
    %Define more parameters
    %k_rand_vel = 1;
    
    %To spread the population
    range = max_range - min_range;
    center = min_range + range/2;
    
    %Others
    n_inf = round(swarmsize*inf_ratio);
    
    %Algorithm Starts
    swarm = {};
    swarm.pose = rand(dimention,swarmsize).*range'*2 - range' + center'; %TODO: initialize
    swarm.vel = (rand(dimention,swarmsize).*range'*2 - range' + center')*1;
    swarm.mem_pose = swarm.pose;
    swarm.mem_fitness = repmat(-Inf,1,swarmsize); %first iteration is pointless so far     
    swarm.best_pose = [];
    swarm.best_fitness = -Inf;
    swarm.progress = zeros(max_it,1); % This will save the progress of the best fitness for plotting out of the function
    
    %x_star = zeros(dimention,swarmsize);
    x_plus = zeros(dimention,swarmsize);
    %x_excl = zeros(dimention,swarmsize);
    

    for it=1:max_it
        %AssesFitness
        fitness = f(swarm.pose')';      
        
        %Update best particles
        for p =1:swarmsize %TODO vectorize
            if fitness(p) > swarm.mem_fitness(p)
                swarm.mem_fitness(p) = fitness(p);
                swarm.mem_pose(:,p) = swarm.pose(:,p);
            end
        end
        %Update best of bests
        [best_f,best_idx] = max(swarm.mem_fitness);
        if best_f > swarm.best_fitness
            swarm.best_fitness = best_f;
            swarm.best_pose = swarm.mem_pose(:,best_idx);
        end
        swarm.progress(it) = swarm.best_fitness;
        
        %fill x_star
        x_star = swarm.mem_pose;
        %fill x_plus. Select gamma random particles and get the best  
        for p=1:swarmsize
            %random permutation that includes the current particle
            idx = [randperm(swarmsize-1,n_inf),p];
            %get best fitness p
            [~,best_idx] = max(swarm.mem_fitness(:,idx));
            %get best particle
            x_plus(:,p) = swarm.mem_pose(:,best_idx);

        end
        %fill x_excl
        x_excl = repmat(swarm.best_pose,1,swarmsize);       
        
        %Get b, c, d
        b = rand(dimention,swarmsize)*beta;
        c = rand(dimention,swarmsize)*gamma;
        d = rand(dimention,swarmsize)*delta;
        
        swarm.vel = alpha*swarm.vel + b.*(x_star-swarm.pose) + c.*(x_plus - swarm.pose) + d.*(x_excl - swarm.pose);        
        swarm.pose = swarm.pose + epsilon*swarm.vel;      
    end
    
    %Update best particles again before finalizing, as updates are done at
    %the end of the algorithm
    for p =1:swarmsize %TODO vectorize
        if fitness(p) > swarm.mem_fitness(p)
            swarm.mem_fitness(p) = fitness(p);
            swarm.mem_pose(:,p) = swarm.pose(:,p);
        end
    end
    %Update best of bests
    [best_f,best_idx] = max(swarm.mem_fitness);
    if best_f > swarm.best_fitness
        swarm.best_fitness = best_f;
        swarm.best_pose = swarm.mem_pose(:,best_idx);
    end

end

%% PSO standard algorithm, visualization (Only 2D input)
function swarm = PSO_standard_viz(swarmsize,alpha,beta,gamma,delta,epsilon,inf_ratio,f,max_it,dimention,min_range,max_range,step)
    %Define more parameters
    k_rand_vel = 1;
    
    %To spread the population
    range = max_range - min_range;
    center = min_range + range/2;
    
    %Others
    n_inf = round(swarmsize*inf_ratio);
    
    %Algorithm Starts
    hold on
    fprintf("Init Particles... ")
    
    tic   
    swarm = {};
    swarm.pose = rand(dimention,swarmsize).*range'*2 - range' + center'; %TODO: initialize
    swarm.vel = rand(dimention,swarmsize)*k_rand_vel*2 - k_rand_vel;
    swarm.mem_pose = swarm.pose;
    swarm.mem_fitness = repmat(-Inf,1,swarmsize); %first iteration is pointless so far     
    swarm.best_pose = [];
    swarm.best_fitness = -Inf;
    swarm.progress = zeros(max_it,1); % This will save the progress of the best fitness for plotting out of the function
    
    toc
    
    %x_star = zeros(dimention,swarmsize);
    x_plus = zeros(dimention,swarmsize);
    %x_excl = zeros(dimention,swarmsize);
    

    %TODO first iteration or start moving
    fprintf("Start Iterating...\n")
    for it=1:max_it
        fprintf("Iteration: %d \n",it);
        %disp(swarm.pose)
        %disp(max(swarm.vel(:)))
        %AssesFitness
        fitness = f(swarm.pose')';      
        
        %Update best particles
        for p =1:swarmsize %TODO vectorize
            if fitness(p) > swarm.mem_fitness(p)
                swarm.mem_fitness(p) = fitness(p);
                swarm.mem_pose(:,p) = swarm.pose(:,p);
            end
        end
        %Update best of bests
        [best_f,best_idx] = max(swarm.mem_fitness);
        if best_f > swarm.best_fitness
            swarm.best_fitness = best_f;
            swarm.best_pose = swarm.mem_pose(:,best_idx);
        end
        
        %Print
        sc = scatter3(swarm.pose(2,:),swarm.pose(1,:),-fitness);
        sc_best = scatter3(swarm.best_pose(2),swarm.best_pose(1),-swarm.best_fitness,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7]);

        
        %fill x_star
        x_star = swarm.mem_pose;
        %fill x_plus. Select gamma random particles and get the best  
        for p=1:swarmsize
            %random permutation that includes the current particle
            idx = [randperm(swarmsize-1,n_inf),p];
            %get best fitness p
            [~,best_idx] = max(swarm.mem_fitness(:,idx));
            %get best particle
            x_plus(:,p) = swarm.mem_pose(:,best_idx);
        end
        %fill x_excl
        x_excl = repmat(swarm.best_pose,1,swarmsize);
          
        %Get b, c, d
        b = rand(dimention,1)*beta;
        c = rand(dimention,1)*gamma;
        d = rand(dimention,1)*delta;
        
        swarm.vel = alpha*swarm.vel + b.*(x_star-swarm.pose) + c.*(x_plus - swarm.pose) + d.*(x_excl - swarm.pose);        
        swarm.pose = swarm.pose + epsilon*swarm.vel;

        pause(step);
        delete(sc);
        delete(sc_best);      
    end
    
end
