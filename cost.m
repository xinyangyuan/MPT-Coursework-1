function [cost] = cost(stress,strain,w,step)
    %{
    Caluculate the Cost/Fitness of an Individual

    Arguments:
    stress -- flow stress from experiment, an array (n_timestep,1) 
    strain -- total strain from experiment, an array  (n_timestep,1)
    w      -- model parameters, an array (n_w,1) essentaily lamda=1
    step   -- time step in numerical integration, a scalar

    Returns:
    cost   -- fitnesses of all individuals (1,1)
    %}

    w_struct = struct('n1',w(1),'n2',w(2),'A',w(3),'B',w(4),'C',w(5),'E',w(6),'k',w(7),'K',w(8));

    % Predict the strain from the model 
    est_strain = model(stress,w_struct,step);

    % Cost Function (least square cost)
    cost = (1/length(strain))*sum((strain - est_strain).^2); 

end