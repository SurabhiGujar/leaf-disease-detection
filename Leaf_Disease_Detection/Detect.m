% Project Title: Leaf Disease Detection

clc
close all 
clear all

%select either dataset or webcam
prompt = 'webcam input?';
x = input(prompt)
if x == 1
   %select image from webcam
    cam = webcam(1);
    preview(cam)
    w = input('take snapshot?');
    if w == 1
        img = snapshot(cam);
    end
    I = (img);
    closePreview(cam);
    clear('cam');
else
    %select image from the dataset
    [filename, pathname] = uigetfile({'*.*';'*.bmp';'*.jpg';'*.gif'}, 'Pick a Leaf Image File');
    I = imread([pathname,filename]);
end

I = imresize(I,[256,256]);
figure, imshow(I); 
title('Input Leaf Image');

%image preprocessing
% Enhance Contrast
I = imadjust(I,stretchlim(I));
figure, imshow(I);
title('Contrast Enhanced');

%% Extract Features

% Function call to evaluate features
[feat_disease seg_img] =  EvaluateFeatures(I);


% Load All The Features
load('Train_Data80.mat')

% Put the test features into variable 'test'
test = feat_disease;
result = multisvm(Train_Feat,Train_Label,test);
%disp(result);

% Visualize Results
if result == 0  
    helpdlg(' Alternaria Alternata ');
    disp(' Alternaria Alternata ');
elseif result == 1
    helpdlg(' Anthracnose ');
    disp('Anthracnose');
elseif result == 2
    helpdlg(' Bacterial Blight ');
    disp(' Bacterial Blight ');
elseif result == 3
    helpdlg(' Cercospora Leaf Spot ');
    disp('Cercospora Leaf Spot');
elseif result == 4
    helpdlg(' Healthy Leaf ');
    disp('Healthy Leaf ');
end

%%
% Evaluate the disease affected area
%graphcut the leaf
I = cut(I);
figure
imshow( I );
% Convert to grayscale if image is RGB
if ndims(seg_img) == 3
   seg_img = rgb2gray(seg_img);
end
%figure, imshow(img); title('Gray Scale Image');
I_affected = imbinarize(seg_img);
%figure, imshow(I_affected);title('Black & White Image');


cc = bwconncomp(I_affected,6);
diseasedata = regionprops(cc,'basic');
A1 = diseasedata.Area;
fprintf('Area of the disease affected region is : %g\n',A1);

% Convert to grayscale if image is RGB
if ndims(I) == 3
   I = rgb2gray(I);
end
%figure, imshow(img); title('Gray Scale Image');
I_leaf = imbinarize(I);
kk = bwconncomp(I_leaf,6);
leafdata = regionprops(kk,'basic');
A2 = leafdata.Area;
fprintf(' Total leaf area is : %g \n',A2);
Affected_Area = (A1/A2);
fprintf('Affected Area is: %g%% \n',(Affected_Area*100))

