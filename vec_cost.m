function [cost] = vec_cost(stress,strain,w,step)
    %{
    Vectorized Implementation of the Fitness/Cost Function

    Arguments:
    stress -- flow stress from experiment, an array (n_timestep,1) 
    strain -- total strain from experiment, an array  (n_timestep,1)
    w      -- model parameters, an array (n_w,lamda) lamda:population size
    step   -- time step in numerical integration, a scalar

    Returns:
    cost   -- fitnesses of all individuals (1,lamda)
    %**********************************************************************
    Author: https://github.com/xinyangyuan
    %**********************************************************************
    %}

    % Predict the strain from the model 
    est_strain = vec_model(stress,w,step);

    % Cost Function (Least square cost)
    cost = abs((1/size(strain,1))*sum((strain - est_strain).^2,1));

end