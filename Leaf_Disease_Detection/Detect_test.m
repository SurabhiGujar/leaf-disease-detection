% Project Title: Leaf Disease Detection

clc
close all 
clear all


for i=1:80
 I = imread(['Dataset\Train_Dataset\',num2str(i),'.jpg']);
I = imresize(I,[256,256]);

%image preprocessing
% Enhance Contrast
I = imadjust(I,stretchlim(I));

% Otsu Segmentation
I_Otsu = im2bw(I,graythresh(I));
% Conversion to HIS

%% Extract Features

% Function call to evaluate features
[feat_disease seg_img] =  EvaluateFeatures(I);


% Load All The Features
load('Train_Data80.mat')

% Put the test features into variable 'test'
test = feat_disease;
result = multisvm(Train_Feat,Train_Label,test);
%disp(result);
predict_mat(:,i) = result;
% % Visualize Results
% if result == 0  
%     helpdlg(' Alternaria Alternata ');
%  %   disp(' Alternaria Alternata ');
% elseif result == 1
%     helpdlg(' Anthracnose ');
%  %   disp('Anthracnose');
% elseif result == 2
%     helpdlg(' Bacterial Blight ');
%  %   disp(' Bacterial Blight ');
% elseif result == 3
%     helpdlg(' Cercospora Leaf Spot ');
%  %   disp('Cercospora Leaf Spot');
% elseif result == 4
%     helpdlg(' Healthy Leaf ');
%  %   disp('Healthy Leaf ');
% end
end
load('Test_Data80.mat');
test_gs = Test_Label;
confusion = confusionmat(test_gs, predict_mat)
accuracy = (trace(confusion))/(sum(sum(confusion)))
%%