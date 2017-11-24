%Numerical Integration methods
function [x] = numIntegration(x,dx,step,technique)
% Check number of inputs.
if nargin > 4
    error('myfuns:somefun2:TooManyInputs', ...
        'requires at most 3 optional inputs');
end

% Set default integration tehnique to euler forward
switch nargin
    case 3
      technique = 'eulerForward';
end
  
switch technique
    case 'eulerForward' 
        x = dx*step + x;
    case 'rungeKutta4'
        k1 = step*(-2*x
end


end
