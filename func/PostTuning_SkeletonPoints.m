function [ PostTunedCode ] = PostTuning_SkeletonPoints(SkeletonPoints, SkeletonPoints_Projection)
%POSTTUNINGTRAIN Summary of this function goes here

    [SkeletonPoints_num,m] = size(SkeletonPoints_Projection);
    X = SkeletonPoints;
    Z = sign(SkeletonPoints_Projection);
    Z(Z==0) = 1; %sign(a) = -1/0/1, we need -1/1

    runtimes = 5;
    % %----------------------------ALgorithm 1(refer to our paper)----------------------------------
    epsion = unifrnd(0.9,1); % Note!!! You need to find a best epsion (refer to Eq.4 and footnote 4 in our paper) for your own data.  
    S= (exp(-distMat(X, X))-exp(-epsion))/exp(-epsion);
    S(S>=0) = 1;
    S =S'*m; %so gamma = 1/m is no longer needed,refer to Eq.8
    U = ones(size(Z)); %Initial post-tuning matrix 
    delta = mean(abs(SkeletonPoints_Projection(:)));
    for iter = 1:runtimes
        for  p = 1:m
            Q = Z(:,p)*Z(:,p)';
            
            T = (U.*Z);
            T(:,p) = [];
            index = abs(SkeletonPoints_Projection(:,p)) <= delta;
            O = T(index,:)*T';
            
            C = Q(index,:).*(S(index,:)-O);
            
            index = find(index==1);
            for q = 1:size(index) 
                va = C(q,:)*U(:,p)-C(q,index(q))*U(index(q),p);
                if(va*U(index(q),p)<0)
                    U(index(q),p) = -U(index(q),p);
                end
            end 
        end
    end

    %output
    PostTunedCode = sign(U.*Z);   

end

