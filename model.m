function [strain] = model(stress,w_struct,step)
    %{
    Implementation of the Physical Model (Non-vectorized)

    Arguments:
    stress -- flow stress, an array (n_timestep,1) 
    w      -- model parameters, a struct {n_w:values} essentaily lamda=1
    step   -- time step in numerical integration, a scalar

    Returns:
    est_strain -- estimated strain calculated from w (n_timestep,1)
    %**********************************************************************
    Author: https://github.com/xinyangyuan
    %**********************************************************************
    %}

    % Retrive Training Parameters
    n1 = w_struct.n1;
    n2 = w_struct.n2;
    A = w_struct.A;
    B = w_struct.B;
    C = w_struct.C;
    E = w_struct.E;
    k = w_struct.k;
    K = w_struct.K;

    % Initilize Variables
    rho = zeros(size(stress));
    R   = zeros(size(stress)); % R = B*rho^(0.5)
    ep  = zeros(size(stress));
    rho(1) = 0.00001;%realmin to approx 0, since 0 -> math error

    for i = 1:length(stress)-1
        % Rate updating step
        dep = ((stress(i+1,1)-R(i,1)-k)/K).^(n1);
        drho = A*(1-rho(i,1))*dep - (C*rho(i,1).^(n2));
        dR = 0.5 *B*(rho(i,1).^(-0.5))*drho;
        % Value updating step
        ep(i+1,1)  = eulerForward(ep(i,1),dep,step);
        rho(i+1,1) = eulerForward(rho(i,1),drho,step);
        R(i+1,1)   = eulerForward(R(i,1),dR,step);
    end

    % Calulate the stress
    strain = (stress./E) + ep;
    
end
    
    
