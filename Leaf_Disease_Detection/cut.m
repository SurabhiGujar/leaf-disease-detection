function [ out_img ] = cut(I)
addpath(genpath('GCmex1.5'));
img = im2double(I);

H = size(img, 1); 
W = size(img, 2); 
K = 3;

imshow(img);

[x,y] = ginput(5);
polygon = poly2mask(x, y, size(img, 1), size(img,2));
%figure(2)
%imshow(polygon);
%polygon = poly2mask(rectangle('Position', [137, 251, 479, 35]));

% for foreground dist
c = {};
for k=1:K
  t=img(:,:,k); 
  c{k} = t(logical(polygon));
end
c = cell2mat(c)
fg_dist = gmdistribution.fit(c, 4, 'regularize', 0.1)


p_fg = pdf(fg_dist, reshape(img, [H*W K]) );
p_fgImg = reshape(p_fg, [H W] );
llhfg = -log(p_fgImg);
% for background dist
c = {};
for k=1:K
  t=img(:,:,k); 
  c{k} = t(~logical(polygon));
end
c = cell2mat(c);
bg_dist = gmdistribution.fit(c, 4, 'regularize', 0.1);
p_bg = pdf(bg_dist, reshape(img, [H*W K]) );
p_bgImg = reshape(p_bg, [H W] );
llhbg = -log(p_bgImg);

%calculating gradient
gx = {}; gy = {};
sigma = 0.025;
for k=1:K
  [gx{k}, gy{k}] = gradient(img(:,:,k));
end

gx = sum(cat(3, gx{:}).^2, 3);
gy = sum(cat(3, gy{:}).^2, 3);
%contrast sensitive terms
hC = 2-exp(-gx/(2*sigma));
vC = 2-exp(-gy/(2*sigma));
lambda = 5;
%calculate smoothness cost
SmoothnessCost = [0 1; 1 0]*lambda;
%calculate data cost
DataCost = cat(3, llhfg, llhbg);

gch = GraphCut('open', DataCost, SmoothnessCost, vC, hC);

[gch labels] = GraphCut('swap', gch,10);

im1=img(:,:,1);
im2=img(:,:,2);
im3=img(:,:,3);
im1(labels==1)=1;
im2(labels==1)=1;
im3(labels==1)=1;
out_img = cat(3, im1, im2, im3);

end

