function df = jacobianState(x)

% xÎª×´Ì¬ÏòÁ¿£»
global T;
w = x(5);
df = zeros(5);

df(1,1) = 1;
df(1,2) = sin(w*T)/w;
df(1,4) = (cos(w*T)-1)/w;
df(1,5) = (w*T*cos(w*T)-sin(w*T))*x(2)/w^2-(w*T*sin(w*T)+cos(w*T)-1)*x(4)/w^2;

df(2,2) = cos(w*T);
df(2,4) = -sin(w*T);
df(2,5) = -T*sin(w*T)*x(2) - T*cos(w*T)*x(4);

df(3,2) = (1-cos(w*T))/w;
df(3,3) = 1;
df(3,4) = sin(w*T)/w;
df(3,5) = (w*T*sin(w*T)+cos(w*T)-1)*x(2)/w^2 + (w*T*cos(w*T)-sin(w*T))*x(4)/w^2;


df(4,2) = sin(w*T);
df(4,4) = cos(w*T);
df(4,5) = T*cos(w*T)*x(2) - T*sin(w*T)*x(4);

df(5,5) = 1;
end