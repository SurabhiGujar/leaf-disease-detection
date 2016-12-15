% Feature Extraction Function
function [feat_disease seg_img] =  EvaluateFeatures(I)
% Color Image Segmentation using K mean clustering 

 cform = makecform('srgb2lab');
 lab_he = applycform(I,cform);
% 
% Classify the colors in a*b* colorspace using K means clustering.
%
 ab = double(lab_he(:,:,2:3));
 nrows = size(ab,1);
 ncols = size(ab,2);
 ab = reshape(ab,nrows*ncols,2);
 nColors = 3;

[cluster_idx cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
pixel_labels = reshape(cluster_idx,nrows,ncols);

% Create a blank cell array to store the results of clustering
segmented_images = cell(1,3);
y = cell(1,3);
thresh = cell(1,3);

% Create RGB label using pixel_labels
rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors = I;
    colors(rgb_label ~= k) = 0;
    segmented_images{k} = colors;
    %masking the green pixels 
    y{k} = segmented_images{k};
    yd = double(y{k})/255;
    %Greenness = G*(G-R)*(G-B)
    greenness = max(yd(:,:,2),0).*max(yd(:,:,2)-yd(:,:,1),0).*max(yd(:,:,2)-yd(:,:,3),0);
    %fprintf(' greenness{%d} : %d\n',k, mean(mean(greenness)));
    thresh{k} = mean(mean(greenness));
end

thresh = cell2mat(thresh);
%thresh(isnan(thresh))=1;
[M,Index] = min(thresh);
%fprintf(' min threshold{%d} : %d\n',Index, M);

seg_img = segmented_images{Index};
%seg_img = im2bw(seg_img,graythresh(seg_img));

% Convert to grayscale if image is RGB
if ndims(seg_img) == 3
   img = rgb2gray(seg_img);
end
%figure, imshow(img); title('Gray Scale Image');

% Create the Gray Level Cooccurance Matrices (GLCMs)
glcms = graycomatrix(img);

% Derive Statistics from GLCM
stats = graycoprops(glcms,'Contrast Correlation Energy Homogeneity');
Contrast = stats.Contrast;
Correlation = stats.Correlation;
Energy = stats.Energy;
Homogeneity = stats.Homogeneity;

Mean = mean2(seg_img);
Standard_Deviation = std2(seg_img);
Entropy = entropy(seg_img);
RMS = mean2(rms(seg_img));
Variance = mean2(var(double(seg_img)));

a = sum(double(seg_img(:)));
Smoothness = 1-(1/(1+a));
Kurtosis = kurtosis(double(seg_img(:)));
Skewness = skewness(double(seg_img(:)));
%Inverse Difference Moment
m = size(seg_img,1);
n = size(seg_img,2);
in_diff = 0;
for i = 1:m
    for j = 1:n
        temp = seg_img(i,j)./(1+(i-j).^2);
        in_diff = in_diff+temp;
    end
end
IDM = double(in_diff);

inertia = 0;
for i = 1:m
    for j = 1:n
        temp = seg_img(i,j).*((i-j).^2);
        inertia = inertia+temp;
    end
end
Inertia = double(inertia);

%set1
%feat_disease = [Contrast,Correlation,Energy,Homogeneity];
%set2
%feat_disease = [Mean, Standard_Deviation, Entropy, RMS, Variance];   
%set3
% feat_disease = [skewness, kurtosis];
%set4
% feat_disease = [IDM, Inertia];
%total set
feat_disease = [Contrast,Correlation,Energy,Homogeneity, Mean, Standard_Deviation, Entropy, RMS, Variance, Smoothness, Kurtosis, Skewness, IDM, Inertia];