function [xi, w] = third_cubature(nx)
    numPoints = 2*(nx + 1);
    w = 1/(2*nx+2);
    xi = zeros(nx,numPoints);

    ar = zeros(nx,nx+1);
    temp = sqrt(nx);
    xCur = 1;
    for r = 1:(nx+1)
        for k = 1:(r-1)
            ar(k,r) =  -sqrt((nx+1)/(nx*(nx-k+2)*(nx-k+1)));
        end
        %for k=r;
        %This had a TYPO in Lu and Darmofal's paper that was
        %correcting using Mysovskikh paper (which itself is missing
        %a closed parenthesis in one part).
        if r < nx + 1
            ar(r,r) = sqrt((nx+1)*(nx-r+1)/(nx*(nx-r+2)));
        end
        %for all higher k, it is zero.

        xi(:,xCur) = temp*ar(:,r);
        xi(:,xCur+1) = -temp*ar(:,r);
        xCur = xCur+2;
    end
end