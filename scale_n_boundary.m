function [w] = scale_n_boundary(w,scaleBool,scaleMethod,boundaryBool,boundary)
    %{
    Scaling and Assigning Boundaries of Parameters W

    Arguments:
    w   -- model parameters, an array (n_w,lamda) lamda:population size
    scaleBool    -- indicates which w is scaled, a bool array (n_w,1)
    scaleMethod  -- indicates scale operation, a cell (n_w,1)
    boundaryBool -- indicates which w is bounded, a bool array (n_w,1)
    boundary     -- indicates the boundary, an array(n_w,2)
    

    Returns:
    w   -- scaled & bounded model parameters, an array (n_w,lamda)
    %**********************************************************************
    Author: https://github.com/xinyangyuan
    %**********************************************************************
    %}

    % Retrive Training Parameters
    for w_idx = 1:size(w,1)
        if scaleBool(w_idx)==1
            if  strcmp(scaleMethod(w_idx),'large')
                w(w_idx,:) = 10.^(w(w_idx,:));
            end
        end

        if boundaryBool(w_idx)==1
            a = boundary(w_idx,1);
            if isnan(boundary(w_idx,2))
                w(w_idx,:) = a + w(w_idx,:).^2;
            else
                b = boundary(w_idx,2);
                w(w_idx,:) = a + (b-a) .* (1 - cos(pi.*w(w_idx,:)./10))./2;
            end
        end
    end
end
