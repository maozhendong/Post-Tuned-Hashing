function [ PostTunedCode ] = PostTuning_OutofSample(SkeletonPoints,SkeletonPointsCode,Data,Data_Projection)
%Out-of-sample extension 
   X = Data;
   Y = sign(Data_Projection);
   B = SkeletonPointsCode;

   % %---------------------out-of-sample extension-------------------------------
   runtimes = 5;
   [test_num,d] = size(Data_Projection);
   U = ones(size(Y)); 
   epsion = unifrnd(0.9,1); %it should be the same with that used in PostTuning_SkeletonPoints.m (see Eq.4).
   S= (exp(-distMat(SkeletonPoints, X))-exp(-epsion))/exp(-epsion);
   S(S>=0) = 1;
   S =S'*d;
   Thre = mean(abs(Data_Projection(:)));
   for iter = 1:runtimes
        for  m = 1:d    
            TY = (U.*Y);
            TY(:,m) = [];
            TB = B;
            TB(:,m) = [];
            W = TY*TB';
            O = (S - W).*repmat(B(:,m)',size(S,1),1);
            v = sign(sum(O, 2).*Y(:,m)); 
            
            Um = ones(size(U(:,m)));
            index = abs(Data_Projection(:,m)) <= Thre;
            Um(index) = v(index);
            U(:,m) = Um;
        end    
   end

   PostTunedCode = U.*Y;

end

