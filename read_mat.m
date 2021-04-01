clear all; close all;

%% Data Access - import Breast area 
%----------------------------------------------------------------------

[filename,pathname,q]=uigetfile({'*.mat'}, 'Load the Breast area file');
if q>0
fn=strcat(pathname,filename);
end
load(fn);
[xdim,ydim,zdim]=size(re_img);


figure('Name','Breast area Image','NumberTitle','off'), imshow3D(re_img);

fin_img = re_img;

%% 座標軸轉換 x<->y&z反轉
for i= 1:xdim
   for j= 1:ydim
       for k= 1:zdim
          out_img(i,j,k)=fin_img(j,i,zdim-k+1); 
       end
   end
end


%% Data Access - Write 3D binary raw file 
pathname=uigetdir('','Select directory to save the binary raw file.');
fn=strcat(pathname,'\breast_area.raw');
fileID = fopen(fn,'w');
fwrite(fileID,out_img,'uint8');
fclose(fileID);
