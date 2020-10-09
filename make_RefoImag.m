clc; clear all;
close all;
addpath(genpath('LFToolbox0.4'));
SAIs_path = dir('./HEVC_flowers_44/*.bmp');
depth_res = 9; %9 Refocus Images
%The minimum slope and maximum slope corresponding to each scene
%For maximum and minimum slope values, please refer to
% L. Shi, S. Zhao, W. Zhou and Z. Chen, "Perceptual Evaluation of Light Field Image," 
% 2018 25th IEEE International Conference on Image Processing (ICIP), Athens, 2018, pp. 41-45.
% Here, we provide the scope of slope in Win5-LID database.
% A toolkit is needed to generate the refocusing image,
% that is, LFToolbox0.4
% please refer to 
% D. Dansereau, ¡°Light field toolbox v0.4,¡± 2016.
%Bike: [-0.68 1.06]
%Dishes: [-3.1 3.5]
%Flowers: [-0.34 0.36]
%Greek: [-3.5 3.1]
%Museum: [-1.5 1.3]
%Palais: [-0.87 0.37]
%Rosemary: [-1.8 1.8]
%Sphynx: [-0.34 0.38]
%Swans: [-0.35 0.36]
%Vespa: [-0.54 0.80]
for k = 1:81
    k
    SAI = (imread(strcat(SAIs_path(k).folder,'\',SAIs_path(k).name)));%read each SAI
    SAIGray = (SAI(2:end-1,2:end-1,:));  %crop SAI
    if mod(k,9) == 0
       aa = floor(k/9);
       bb = 9;
    else
       aa = floor(k/9)+1;
       bb = mod(k,9);
    end
    LF(aa,bb,:,:,:) = SAIGray;
end
FiltOptions.InterpMethod = 'cubic';
SLOPE = linspace(-0.34, 0.36, depth_res);
makeDir = ['HEVC_Flowers_RIs_44'];
mkdir(makeDir);
for ns = 1:depth_res
    slope = SLOPE(ns);
    refocus_im = LFFiltShiftSum(LF,slope); 
    imwrite(refocus_im(:,:,1:3),[makeDir,'\',num2str(ns,'%02d'),'.png']);
end
