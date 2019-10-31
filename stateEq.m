
function xOut = stateEq(xIn)

global T;

L = size(xIn,2);
xOut = zeros(size(xIn));

for i = 1:L
    
    x = xIn(:,i);
    omg = x(5);
    
    F = [1 sin(omg*T)/omg 0 -(1- cos(omg*T))/omg 0;
        0 cos(omg*T) 0 -sin(omg*T) 0;
        0  (1- cos(omg*T))/omg 1  sin(omg*T)/omg 0;
        0  sin(omg*T) 0 cos(omg*T) 0;
        0 0 0 0 1];
    
    xOut(:,i) = F*x;   
end;