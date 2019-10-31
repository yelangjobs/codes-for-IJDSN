function S = Sroot(A)
[~,R]=qr(A',0);

S=R';