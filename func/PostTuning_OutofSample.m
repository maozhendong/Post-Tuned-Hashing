function [ PostTunedCode ] = PostTuning_OutofSample(SkeletonPoints,SkeletonPointsCode,Data,Data_Projection)

   X = Data;
   Z = sign(Data_Projection);
   Z(Z==0) = 1;
   B = SkeletonPointsCode;
   [sample_num,m] = size(Data_Projection); 
   
   runtimes = 5;
   % %---------------------out-of-sample extension-------------------------------
   epsion = unifrnd(0.9,1); %Note!!!,it should be the same with that used in PostTuning_SkeletonPoints.m (refer to Eq.4 and footnote 4 in our paper).
   S= (exp(-distMat(SkeletonPoints, X))-exp(-epsion))/exp(-epsion);
   S(S>=0) = 1;
   S =S'*m; %so gamma = 1/m is no longer needed,refer to Eq.8
   U = ones(size(Z)); %Initial post-tuning matrix 
   delta = mean(abs(Data_Projection(:)));
   for iter = 1:runtimes
        for  p = 1:m    
            TY = (U.*Z);
            TY(:,p) = [];
            TB = B;
            TB(:,p) = [];
            O = TY*TB';
            C = (S - O).*repmat(B(:,p)',size(S,1),1);
            v = sign(sum(C, 2).*Z(:,p)); 
            
            U_p = ones(size(U(:,p)));
            index = abs(Data_Projection(:,p)) <= delta;
            U_p(index) = v(index);
            U(:,p) = U_p;
        end    
   end

   %output
   PostTunedCode = U.*Z;

end

