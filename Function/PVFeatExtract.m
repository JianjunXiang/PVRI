function f = PVFeatExtract(LF4D)
%extract PV feat
f = [];
[u,v,s,t] = size(LF4D);
LF4D = double(LF4D);
for uu = 1:u
    ColAngDom = squeeze(LF4D(uu,:,:,:)); % one PGoF
    ColVideo = permute(ColAngDom,[2,3,1]);
    [ColFirst,ColOthers] = tendec(ColVideo,s,t,v);% tensor decomposition
    % normalization
    ColFirst = abs(ColFirst);
    norm_ColFirst = (ColFirst-min(ColFirst(:)))/(max(ColFirst(:))-min(ColFirst(:)))*255;
    ColOther = sum(abs(ColOthers),3); % difference map
    ColFirstMetrix(:,:,uu) = norm_ColFirst; 
    ColOtherMetrix(:,:,uu) = ColOther;
    Feat(uu,:) = STFeatExtract(norm_ColFirst); % extract PV spatial structure features
end
for i = 1:u-1
    Sub(:,:,i) = abs(ColFirstMetrix(:,:,i)-ColFirstMetrix(:,:,i+1)); 
end
CrossGOFFeat = mean(Sub,3);
ColOtherSum = mean(ColOtherMetrix,3);
f = [f mean(Feat)];
f = [f STFeatExtract(ColOtherSum)]; % extract motion features
f = [f STFeatExtract(CrossGOFFeat)]; % extract disparity information