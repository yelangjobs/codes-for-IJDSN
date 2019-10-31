function y = MatReshape(x)
% x是一个三维矩阵，转换为二维矩阵
ndim = size(x);
y = reshape(x,ndim(1),ndim(2)*ndim(3));
