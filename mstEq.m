function z = mstEq(x,s)

r = sqrt(sum((x([1,3],:) - repmat(s,1,size(x,2))).^2,1));

theta = atan2(x(3,:)-s(2),x(1,:)-s(1));

z = [r;theta];