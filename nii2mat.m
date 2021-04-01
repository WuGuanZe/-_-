clear all;
close all;

[filename,pathname,q]=uigetfile({'*.nii'}, 'Load the Breast area nii file');
if q>0
fn=strcat(pathname,filename);
end
info = nii_read_header(fn);
volume = nii_read_volume(info);
im=logical(volume);
figure('Name','Original Image','NumberTitle','off'), imshow3D(im);
[xdim,ydim,zdim]=size(im);

% z_resolution=10;
% for i=1: z_resolution
%     rs_img=imresize(im(:,:,round(i*(55/z_resolution))), [512 512]);
%     f_img(:,:,i)=rs_img;
% end

fin_img = im;

%% 座標軸轉換 x<->y&z反轉
for i= 1:xdim
   for j= 1:ydim
       for k= 1:zdim
          re_img(i,j,k)=fin_img(j,i,zdim-k+1); 
       end
   end
end

fn=strcat(pathname,'\breast_area_nii.mat');
save(fn,'re_img');
figure('Name','Original Image','NumberTitle','off'), imshow3D(re_img);

