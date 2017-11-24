function [x] = eulerForward(x,dx,step)
    %{
    Euler Numerical Integration

    Arguments:
    x    -- value of x at time t, an array  
    dx   -- rate of x at time t, an array
    step -- time step in numerical integration, a scalar
    

    Returns:
    x   -- value of x at time t+1, an array 
    %**********************************************************************
    Author: https://github.com/xinyangyuan
    %**********************************************************************
    %}
    x = dx*step + x;
end
