function [ PostTunedCode ] = PostTuning_SkeletonPoints(SkeletonPoints, SkeletonPoints_Projection)
%POSTTUNINGTRAIN Summary of this function goes here
%   Detailed explanation goes here

[SkeletonPoints_num,d] = size(SkeletonPoints_Projection);
X = SkeletonPoints;
Y = sign(SkeletonPoints_Projection);


% %----------------------------ALgorithm 1----------------------------------
    runtimes = 5;
    U = ones(size(Y));
    epsion = unifrnd(0.9,1); % Note!!! You need to find a best epsion (see Eq.4) for your own data (if you want to test PTH on another dataset).  
    S= (exp(-distMat(X, X))-exp(-epsion))/exp(-epsion);
    S(S>=0) = 1;
    S =S'*d;
    Thre = mean(abs(SkeletonPoints_Projection(:)));
    for iter = 1:runtimes
        for  m = 1:d
            Ym = Y(:,m)*Y(:,m)';
            T = (U.*Y);
            T(:,m) = [];

            index = abs(SkeletonPoints_Projection(:,m)) <=Thre;
            W = T(index,:)*T';
            O = (S(index,:)-W).*Ym(index,:);
            index = find(index==1);
           
            for i = 1:size(index) 
                va = O(i,:)*U(:,m)-O(i,index(i))*U(index(i),m);
                if(va*U(index(i),m)<0)
                    U(index(i),m) = -U(index(i),m);
                end
            end 
        end
    end

    PostTunedCode = sign(U.*Y);   

end

