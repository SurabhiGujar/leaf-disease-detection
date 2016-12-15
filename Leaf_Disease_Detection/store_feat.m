%first run this to evaluate features from training
for i=1:80
   im_train = imread(['Dataset\Train_Dataset\',num2str(i),'.jpg']); 
   [feat_train seg_img] =  EvaluateFeatures(im_train);
   Train_Feat(i,:) = feat_train;
 end
%store test and train labels 
Train_Label(1:20) = 0;
Train_Label(21:40) = 1;
Train_Label(41:60) = 2;
Train_Label(61:80) = 3;

Test_Label(1:20) = 0;
Test_Label(21:40) = 1;
Test_Label(41:60) = 2;
Test_Label(61:80) = 3;

save Test_Data80.mat Test_Label;
save Train_Data80.mat Train_Feat  Train_Label;
