function f = RefocusImgFeatExtract(dir_path)
    num = 0;
for k = 1:9
    num = num +1 ;
    disRefocusImg = imread(strcat(dir_path(k).folder,'\',dir_path(k).name));
    [x,y,c] = size(disRefocusImg);
    [disRefocusImgFirst,~] = tendec(disRefocusImg,x,y,c);% tenor decomposition
    disRefocusImgFirst = abs(disRefocusImgFirst);
    %normalization
    normRF = (disRefocusImgFirst-min(disRefocusImgFirst(:)))/(max(disRefocusImgFirst(:))-min(disRefocusImgFirst(:)))*255;
    GWHGLBPFeat(num,:) = gwhglbp_feature(normRF);% extract RIs spatial features
    RefocusImgStack(:,:,num) = normRF;
end
[RFStackFeat] = LIG(RefocusImgStack);% extract RIs depth features
f = [RFStackFeat mean(GWHGLBPFeat)];
end