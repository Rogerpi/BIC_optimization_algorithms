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
    
    best_swarm = {};
    best_swarm.pose = swarm.pose;
    best_swarm.vel = swarm.vel;
    best_swarm.fitness = repmat(-Inf,1,swarmsize); %first iteration is pointless so far     
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
        
        sc = scatter3(swarm.pose(2,:),swarm.pose(1,:),-fitness);
        %Update best particles
        for p =1:swarmsize %TODO vectorize
            if fitness(p) > best_swarm.fitness(p)
                best_swarm.fitness(p) = fitness(p);
                best_swarm.pose(:,p) = swarm.pose(:,p);
            end
        end
        %fill x_star
        x_star = best_swarm.pose;
        %fill x_plus. Select gamma random particles and get the best  
        for p=1:swarmsize
            %random permutation that includes the current particle
            others = [1:p-1,p+1:swarmsize];
            idx = [randperm(swarmsize-1,n_inf),p];
            %get best fitness p
            [~,best_idx] = max(best_swarm.fitness(:,idx));
            %get best particle
            x_plus(:,p) = best_swarm.pose(:,best_idx);

        end
        %fill x_excl
        [~,best_idx] = max(best_swarm.fitness);
        x_excl = repmat(best_swarm.pose(:,best_idx),1,swarmsize);
        
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
        
    end
end

