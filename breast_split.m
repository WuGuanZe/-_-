clear all; close all;

%% Data Access - import Breast area 
%----------------------------------------------------------------------

[filename,pathname,q]=uigetfile({'*.mat'}, 'Load the Breast area file');
if q>0
fn=strcat(pathname,filename);
end
load(fn);
[xdim,ydim,zdim]=size(re_img);

%figure('Name','Breast area Image','NumberTitle','off'), imshow3D(re_img);

se = strel('cuboid',[3 3 3]);

BW1 = imclose(re_img,se);
BW2 = imopen(BW1,se);
BW2 = imopen(BW2,se);

both_img = BW2;

%% split left & right breast

for i= 1:xdim
   for j= 1:ydim
       for k= 1:zdim
           if j<(ydim/2)
                left_img(i,j,k)=0;
                right_img(i,j,k)=both_img(i,j,k); 
           else
                left_img(i,j,k)=both_img(i,j,k); 
                right_img(i,j,k)=0; 
           end

       end
   end
end

%figure('Name','Breast area Image','NumberTitle','off'), imshow3D(right_img);
%figure('Name','Breast area Image','NumberTitle','off'), imshow3D(left_img);

out_img=right_img;
fn=strcat(pathname,'\breast_right.mat');
save(fn,'out_img');

out_img=left_img;
fn=strcat(pathname,'\breast_left.mat');
save(fn,'out_img');


