%   This toy demo shows the complete process of Post Tuned Hashing, using "ITQ + Post-Tuning" as the example.
%   dataset: Gaussian Mixture Dataset, 4000 2-d points from 4 different Gaussian distributions.

addpath('./func/');
clc;clear all;close all;

%load Dataset.
load('GaussianMixtureData');
data = GaussianMixtureData;


%-----------------------------------compute codes ---------------------------------
CodeLength = 2;
%ITQ 
[pc, l] = eigs(cov(data),CodeLength);
[Y, R] = ITQ(data*pc,50); 
ITQcodes = sign(data*pc*R);

%PostTuning
RandSample = randperm(size(data,1)); %generate random index
SkeletonPoints = data(RandSample(1:100),:); %randomly select 100 points as Skeleton Points
%step 1: post-tuning skeleton points
PTH_SkeletonPoints_codes = PostTuning_SkeletonPoints(SkeletonPoints,SkeletonPoints*pc*R); % post-tuning skeleton points
%step 2: post-tuning database
PTH_data_codes = PostTuning_OutofSample(SkeletonPoints,PTH_SkeletonPoints_codes,data,data*pc*R);% post-tuning database



%---------------------------------show data and codes -----------------------------
%show data
f1 = figure; ShowbyCode(data,[]); title('1. original data points from 4 Gaussian distributions');
%show ITQ codes
f2 = figure; ShowbyCode(data,ITQcodes); title('2. ITQ codes (2-bits) of data points');
%show training set post-tuning results
f3 = figure; ShowbyCode(SkeletonPoints,PTH_SkeletonPoints_codes); title('3. post-tuned ITQ codes of skeleton points (100 random points)');
%show data post-tuning results
f4 = figure; ShowbyCode(data,PTH_data_codes); title('4. post-tuned ITQ codes of the remaining out-of-sample points');
%show 4 figure(f1,f2,f3,f4) together
Image = {getframe(f1),getframe(f2),getframe(f3),getframe(f4)};
if(isequal(size(Image{1}.cdata),size(Image{2}.cdata)) && isequal(size(Image{3}.cdata),size(Image{4}.cdata)))
    upimage = cat(2,Image{1}.cdata,Image{2}.cdata); downimage = cat(2,Image{3}.cdata,Image{4}.cdata);
    if(isequal(size(upimage),size(downimage)))
        pic=cat(1,upimage,downimage);
        figure, imshow(pic);title('Toy illustration of the process (from 1 to 4) of a PTH method, i.e. ITQ + Post-Tuning.');
    end
end


