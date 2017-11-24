classdef fitting < handle
    %{
    Fitting Class
    %**********************************************************************
    The fitting class is a functional prototype, and code is not optimized
    at all.
    TODO:   Getters and Setters Functions
            Optimize visulization loop
            Detailed documentation   
    Author: https://github.com/xinyangyuan
    %**********************************************************************

    %}
    properties
        % model properties
        w = [];               %Initial estimate of the parameters
        n_w = 8;              %Problem dimension(dimension of w) in this case n_w=8
        step = 0.0002;        %Time step in numerical (euler) integration
        stress;               %Experimental stress data
        strain;               %Experimental strain data
        
        % fitted results
        best = [];            %Best individuals among generations (n_w,generations)
        best_fitness = [];    %Fitness of the best individuals among gnerations (1,generations)
        
        % scales and constriants
        scaleBool    = [0,0,0,0,0,1,0,0];
        scaleMethod  = {0,0,0,0,0,'large',0,0};
        constriants = 'positive';                %Constriants/boundaries on w, default all bositive 
        boundaryBool = [1,1,1,1,1,1,1,1];        %On/off of boundary constriants  (SHOULD PARAMETERIZE with n_w!)
        boundary = [0,nan;0,nan;0,nan;0,nan;...  %Boundary constraints values     (SHOULD PARAMETERIZE with n_w!)
                    0,nan;0,nan;0,nan;0,nan];
        
        % cames settings
        sigma = 0.3;           %initial learning rate between generations 
        lamda = 2000;          %population size
        f_evals_max = [];      %max number of fitness evaluations,limit of lamda*generations
        g_max;                 %max number of generations
                
        % extra utilities
        display = 0;           %On/off display of best fitness values among iterations
    end
    
    
    methods
        function obj = fitting(stress,strain)
            obj.stress = stress;
            obj.strain = strain;
        end
        
        function obj = set.display(obj,display)
            if display == 0 || display == 1
                obj.display = display;
            else
                disp('Invalid Display Settings, either 0 or 1')
            end
        end
                
        function obj = set.constriants(obj,mode)
            if strcmp(mode,'positive')
                obj.constriants = 'positive';
            elseif strcmp(mode,'auto')
                obj.constriants = 'auto';
            elseif strcmp(mode,'manual')
                obj.constriants = 'manual';
            else
                disp('Invalid Constraints Setting')
            end
        end
                
        
        function run(obj)
            % initialize the learning parameters
            obj.w = rand(1,obj.n_w);
            
            % set the constriants to pre-set boundary values
            if strcmp(obj.constriants,'auto') 
                obj.boundaryBool = [1,1,1,1,1,1,1,1];
                obj.boundary = [1,5;1,5;1,nan;1,nan;1,nan;10,100000000;1,nan;1,nan];
            end
            
            % if user not input max # of evaluations, set to default value
            if isempty(obj.f_evals_max)
                opts.f_evals_max = (10 ^ 4) * obj.n_w;
            else
                opts.f_evals_max = obj.f_evals_max;
            end
            
            % set population size
            opts.lambda = obj.lamda;       
            
            % INITIALIZE CAMES OPTIMIZATION CLASS
            opt = cmaes(obj.w, obj.sigma , opts);       
            
            stop = 0;
            g = 0;
            
            if obj.display == 1
                curve = animatedline('Color','r','Marker','o');
                grid on;
                legend('Fitness Score');
                
                % Fitting loop
                while (~stop)
                    g = g + 1;
                    if g > obj.g_max
                        break
                    end
                    
                    solutions = opt.ask()';
                    solutions = scale_n_boundary(solutions,obj.scaleBool,obj.scaleMethod,obj.boundaryBool,obj.boundary);
                    fitnesses = vec_cost(obj.stress,obj.strain,solutions,obj.step);
                    stop = opt.tell(fitnesses);
                    
                    best_tmp = scale_n_boundary(opt.get_m()',obj.scaleBool,obj.scaleMethod,obj.boundaryBool,obj.boundary);
                    F = vec_cost(obj.stress,obj.strain,best_tmp,obj.step);

                    obj.best = [obj.best,best_tmp];
                    obj.best_fitness = [obj.best_fitness,F];

                    disp(F);
                    addpoints(curve,g,log10(abs(F)));
                    drawnow
                end
            else
                % Fitting loop
                while (~stop)
                    g = g + 1;
                    if g > obj.g_max
                        break
                    end
                    
                    solutions = opt.ask()';
                    solutions = scale_n_boundary(solutions,obj.scaleBool,obj.scaleMethod,obj.boundaryBool,obj.boundary);
                    fitnesses = vec_cost(obj.stress,obj.strain,solutions,obj.step);
                    stop = opt.tell(fitnesses);
                    
                    best_tmp = scale_n_boundary(opt.get_m()',obj.scaleBool,obj.scaleMethod,obj.boundaryBool,obj.boundary);
                    F = vec_cost(obj.stress,obj.strain,best_tmp,obj.step);

                    obj.best = [obj.best,best_tmp];
                    obj.best_fitness = [obj.best_fitness,F];
                    
                    disp(F);
                end
            end
            
            best_finalitr = scale_n_boundary(opt.get_m()',obj.scaleBool,obj.scaleMethod,obj.boundaryBool,obj.boundary);
            est_strain = vec_model(obj.stress,best_finalitr,0.0002);
            
            obj.best = scale_n_boundary(obj.best,obj.scaleBool,obj.scaleMethod,obj.boundaryBool,obj.boundary);
            
            figure
            plot(obj.strain,obj.stress,est_strain,obj.stress)
            %set(gca, 'FontName', 'PT Sans')
            legend('experiment','fitted model','Location','southeast')
            xlabel('Strain [%] ','FontSize',12,'FontWeight','bold')
            ylabel('Stress [MPa] ','FontSize',12,'FontWeight','bold')
        end
        
        function [max_w,max_fitness] = result(obj)
            [max_fitness,idx] = max(obj.best_fitness);
            max_w = obj.best(:,idx);
        end
            
            
    end
end