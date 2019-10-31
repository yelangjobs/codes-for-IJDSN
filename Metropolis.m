% Metropolis 权重
function W = Metropolis(E)

% 输入：网络的邻接矩阵
% 输出： Metropolis权重矩阵

Ns = size(E,1); % 传感器个数
W = zeros(Ns);
d = sum(E,2);   % 节点度

for i = 1:Ns
    for j = 1:Ns
        if E(i,j)
            W(i,j) = 1/(1 + max(d([i,j])));
        end
    end
    W(i,i) = 1 - sum(W(i,:));
end
