function [w] = unscale_n_boundary(w,scaleBool,scaleMethod,boundaryBool,boundary)
    %{
    Reverse Operation of (scale_n_boundary)
    (***this function is not normally used in the assembly,unless users want
    to put manual estimate of the parameters***)

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
    for w_idx = 1:size(w,1)
        if scaleBool(w_idx)==1
            if  strcmp(scaleMethod(w_idx),'large')
                w(w_idx,:) = log10(w(w_idx,:));
            end
        end

%         if boundaryBool(w_idx)==1
%             a = boundary(w_idx,1);
%             if isnan(boundary(w_idx,2))
%                 w(w_idx,:) = a + w(w_idx,:).^2;
%             else
%                 b = boundary(w_idx,2);
%                 w(w_idx,:) = (10/pi) .* acos(1 - 2*((w(w_idx,:)-a)./(b-a)));
%             end
%         end
    end
end
