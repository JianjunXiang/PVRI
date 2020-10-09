clc;clear ;
close ;
% Demonstration of feature extraction
% Here, we use GWH-GLBP algorithm to extract RIs spatial structure features
% you can refer to 
% [1]Q. Li, W. Lin and Y. Fang, ¡°No-reference quality assessment for multiply-distorted images in gradient domain,¡± 
% IEEE Signal Process. Lett., vol. 23, no. 4, pp. 541-545, Apr. 2016.
% Then, we utilize Shearlet transform to extract PV features. 
% For Shearlet transform, please refer to 
% [2]Y. Li, L.-M. Po, X, Xu, L. Feng, F. Yuan, C.-H. Cheung and K.-W Cheung, ¡°No-reference image quality assessment 
% with shearlet transform and deep neural networks,¡± Neurocomputing, vol. 154, pp. 94-109, Apr. 2015.
% [3] G. Easley, D. Labate, W.-Q. Lim, ¡°Sparse directional image representations using 
% the discrete shearlet transform,¡± Appl. Comput. Harmon. Anal., vol. 25, no. 1, pp. 25-46, Jul. 2008.
addpath(genpath('Function'));
addpath(genpath('tensor'));
addpath(genpath('Shearlet-Transform'));
addpath(genpath('GWH-GLBP-BIQA'));
dis_path = dir('./HEVC_flowers_44/*.bmp');
disRefocus_path = dir('./HEVC_Flowers_RIs_44/*.png');
Feat = [];
RefoImgFeat = RefocusImgFeatExtract(disRefocus_path); %extract RIs features
for k = 1:81
    dis_SAI = (imread(strcat(dis_path(k).folder,'\',dis_path(k).name)));
    [x,y,c] = size(dis_SAI);
    [SAIFirst,SAIOthers] = tendec(dis_SAI,x,y,c);% tensor decomposition;
    SAIFirst = abs(SAIFirst);
    %normalization
    normSAI = (SAIFirst-min(SAIFirst(:)))/(max(SAIFirst(:))-min(SAIFirst(:)))*255;
    % generate PV
    if mod(k,9) == 0
       aa = floor(k/9);
       bb = 9;
    else
       aa = floor(k/9)+1;
       bb = mod(k,9);
    end
    if mod(aa,2) == 1
       LF4D(aa,bb,:,:) = normSAI;
    else 
       LF4D(aa,10-bb,:,:) = normSAI;
    end
end
PVideoFeat = PVFeatExtract(LF4D);% extract PV features;
Feat = [PVideoFeat RefoImgFeat];