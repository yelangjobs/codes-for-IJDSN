function [xi, w] = fifth_cubature(nx)
    numPoints = nx^2 + 3*nx + 3;
    w = zeros(1,numPoints);
    xi = zeros(nx,numPoints);

    xCur = 1;
    w(xCur) = 2/(nx+2); % The first point is the origin.

    %The next 2*(nx+1) points come from calculating a-values, which
    %must be saved to calculate b-values.
    ub = 2*(nx+1) + xCur;
    xCur = xCur + 1;
    w(xCur:ub) = nx^2*(7-nx)/(2*(nx+1)^2*(nx+2)^2);

    ar = zeros(nx,nx+1);
    temp = sqrt(nx+2);
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

    %Now, the final nx*(nx+1) points come from combining all pairs of
    %points.
    w(xCur:end) = 2*(nx-1)^2/((nx+1)^2*(nx+2)^2);

    temp = sqrt(0.5*(nx*(nx+2)/(nx-1)));
    for l = 1:nx
        for k = (l+1):(nx+1)
            
            b = temp*(ar(:,l) + ar(:,k));
            
            xi(:,xCur) = b;
            xi(:,xCur + 1) = -b;
            xCur = xCur+2;
        end
    end
end