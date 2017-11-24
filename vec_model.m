function [est_strain] = vec_model(stress,w,step)
    %{
    Vectorized Implementation of the Physical Model

    Arguments:
    stress -- flow stress, an array (n_timestep,1) 
    w      -- model parameters, an array (n_w,lamda) lamda:population size
    step   -- time step in numerical integration, a scalar

    Returns:
    est_strain -- estimated strain calculated from w (n_timestep,lamda)
    %**********************************************************************
    Author: https://github.com/xinyangyuan
    %**********************************************************************
    %}

    % Retrive Training Parameters
    n1 = w(1,:);
    n2 = w(2,:);
    A = w(3,:);
    B = w(4,:);
    C = w(5,:);
    E = w(6,:);
    k = w(7,:);
    K = w(8,:);

    % Initilize Variables
    rho = zeros(size(stress,1),size(w,2));
    R   = zeros(size(stress,1),size(w,2)); % R = B*rho^(0.5)
    ep  = zeros(size(stress,1),size(w,2));
    rho(1,:) = 0.0000001;%realmin to approx 0, since 0 -> math error

    for i = 1:length(stress)-1
        % Rate updating step
        dep = ((stress(i+1,1)-R(i,:)-k)./K).^(n1); %broadcast stress array
        drho = A.*(1-rho(i,:)).*dep - (C.*rho(i,:).^(n2));
        dR = 0.5 *B.*(rho(i,:).^(-0.5)).*drho;
        % Value updating step
        ep(i+1,:)  = eulerForward(ep(i,:),dep,step);
        rho(i+1,:) = eulerForward(rho(i,:),drho,step);
        R(i+1,:)   = eulerForward(R(i,:),dR,step);
    end

    % Calulate the stress
    est_strain = (stress./E) + ep; 

end
    
    
