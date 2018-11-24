function PSO_standard(swarmsize,alpha,beta,gamma,delta,epsilon,inf_ratio,f)
    %Define more parameters
    %TODO as arguments
    max_it = 400;
    dimention = 2; %y = f(a,b);
    k_rand_vel = 1;
    k_rand_pose = 100;
    
    %Others
    n_inf = round(swarmsize*inf_ratio);
    
    %Algorithm Starts
    hold on
    fprintf("Init Particles... ")
    
    tic   
    swarm = {};
    swarm.pose = rand(dimention,swarmsize)*k_rand_pose*2 - k_rand_pose; %TODO: initialize
    swarm.vel = rand(dimention,swarmsize)*k_rand_vel*2 - k_rand_vel;
    swarm.mem_pose = swarm.pose;
    swarm.mem_fitness = repmat(-Inf,1,swarmsize); %first iteration is pointless so far     
    swarm.best_pose = [];
    swarm.best_fitness = -Inf;
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
        [swarm.best_fitness,best_idx] = max(swarm.mem_fitness);
        swarm.best_pose = swarm.mem_pose(:,best_idx);
        
        %Print
        sc = scatter3(swarm.pose(2,:),swarm.pose(1,:),-fitness);
        sc_best = scatter3(swarm.best_pose(2),swarm.best_pose(1),-swarm.best_fitness,'MarkerEdgeColor',[0 .5 .5],'MarkerFaceColor',[0 .7 .7]);

        
        %fill x_star
        x_star = swarm.mem_pose;
        %fill x_plus. Select gamma random particles and get the best  
        for p=1:swarmsize
            %random permutation that includes the current particle
            others = [1:p-1,p+1:swarmsize];
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
        
        %scatter(swarm.pose(1,:),swarm.pose(2,:));
        %ylim([-150,150])
        %xlim([-150,150])
        %zlim([-1000,10000])

        pause(0.2);
        delete(sc);
        delete(sc_best);
        
    end
end

