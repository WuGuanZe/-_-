clear all; 
close all;

%% Data Access - import organized DICOM 
%----------------------------------------------------------------------

dicom_directory = uigetdir();
listing = dir(dicom_directory);
listing=listing(3:size(listing),1);

fnum=numel(listing);
if (fnum<3)
        error('The folder is empty ???');
        return
end

fnum = 0;
hWaitBar = waitbar(0,'Reading DICOM files');
 for i = 1:length(listing) % loop through directory listing, but skip '.' and '..'
        filename = listing(i).name;
        full_path = fullfile(dicom_directory, filename);
        
                warning off
                
        % Check for good and organized dicom file
        if isdicom(full_path)
            fnum = fnum + 1;
            info = dicominfo(full_path);
            slice_image (:,:,i) = dicomread(info);
                    
            end % if pixel spacing
        
    waitbar(1-(length(listing)-i)/length(listing),hWaitBar);
    end    
   
    waitbar(1,hWaitBar);
    close(hWaitBar);
    whos slice_image

% 取得Dicom檔頭的空間資訊，pixel/mm
%----------------------------------------------------------------------
%extract size info from metadata (nobkpt)
voxel_size = [info.PixelSpacing; info.SliceThickness]';
disp(dicom_directory);

% 讀取乳房區域
%----------------------------------------------------------------------
[filename,pathname,q]=uigetfile({'*.mat'}, 'Load the Breast area file');
if q>0
fn=strcat(pathname,filename);
end
load(fn);

im= uint8(slice_image/(max(max(max(slice_image)))/255));

[xdim,ydim,zdim]=size(im);

brest_radius = 5;
breast_decomposition = 0;
breast_se = strel('disk',brest_radius,breast_decomposition); 
breast_eroded = imerode(out_img,breast_se);

for i=1:xdim
    for j=1:ydim
        for k=1:zdim
            if breast_eroded(i,j,k)==0
               im(i,j,k)=255;                
            end            
        end
    end
end

figure('Name','Original Image','NumberTitle','off'), imshow3D(im);

%% image pre-processing
%----------------------------------------------------------------------
    num_iter = 2;
    delta_t = 1/15;
    kappa = 70;
    option = 2;
    diff_image = anisodiff2D(im,num_iter,delta_t,kappa,option);
    
for i=1:xdim
    for j=1:ydim
        for k=1:zdim
            if (diff_image(i,j,k) < 0.3)
                diff_image_th(i,j,k)=1;
            else
                diff_image_th(i,j,k)=0;
            end
        end
    end
end

 diff_image_th_radius = 1;
 diff_image_th_decomposition = 0;
 diff_image_th_se = strel('disk',diff_image_th_radius,diff_image_th_decomposition); 
 diff_image_th_close = imclose(diff_image_th,diff_image_th_se);
            
% num_iter = 2;
% delta_t = 1/15;
% kappa = 70;
% option = 2;
% voxel_spacing = ones(3,1);
% 
% diff_image = anisodiff3D(im2double(im), num_iter, delta_t, kappa, option, voxel_spacing);
   
disp('3D image are preprocessed.');

%% image segmentation
%----------------------------------------------------------------------
global Current_S; 
figure('Name','Preprocessed Image Anisodiff','NumberTitle','off'), imshow3D(diff_image);
figure('Name','Preprocessed Image Threshold','NumberTitle','off'), imshow3D(diff_image_th_close);
disp('Select a frame and press any key.');
pause;

%----------------------------------------------------------------------
hold on
uiwait(msgbox('Select a seed point...','Image Opened','modal'));
[y,x]=ginput(1);
x=round(x);
y=round(y);
z=round(Current_S);
str=sprintf('The seed point is (%d,%d,%d)', x,y,z);
disp(str);
%----------------------------------------------------------------------

region_image = im2uint8(diff_image_th_close);

%%找7x7x7 較合適的種子點 
%----------------------------------------------------------------------
for i=1:7
    for j=1:7
        for k=1:7
            sp_region(i,j,k)=region_image(x+i-2,y+j-2,z+k-2);
        end
    end
end
sp_max=max(max(max(sp_region)));
sp_min=min(min(min(sp_region)));
sp_med=median(median(median(sp_region)));

for i=1:7
    for j=1:7
        for k=1:7
            if sp_region(i,j,k)==sp_max
                max_x=i-2;
                max_y=j-2;
                max_z=k-2;
            end
            if sp_region(i,j,k)==sp_min
                min_x=i-2;
                min_y=j-2;
                min_z=k-2;
            end
            if sp_region(i,j,k)==sp_med
                med_x=i-2;
                med_y=j-2;
                med_z=k-2;
            end            
        end
    end
end

%%確定種子點是否正確
%----------------------------------------------------------------------
region_image(x+max_x,y+max_y,z+max_z)
region_image(x+min_x,y+min_y,z+min_z)
region_image(x+med_x,y+med_y,z+med_z)

new_x=x+min_x;
new_y=y+min_y;
new_z=z+min_z;

new_x=x+med_x;
new_y=y+med_y;
new_z=z+med_z;

%----------------------------------------------------------------------
%%注意regionGrowing的種子點座標為[x,y,z]
[poly, J] = regionGrowing(region_image, [new_x,new_y,new_z], 10); %, Inf, [], true, false); 
figure('Name','RegionGrowing Result','NumberTitle','off'), imshow3D(J);

%% image post-processing
%----------------------------------------------------------------------
% Open mask with disk，使線條圓滑
radius_01 = 2;
decomposition_01 = 0;
se01 = strel('disk', radius_01, decomposition_01);

%radius_02 = 3;
%decomposition_02 = 0;
%se02 = strel('disk', radius_02, decomposition_02);

F = imclose(J, se01);
F = imopen(F, se01);
F = imerode(F, se01);
%F = imerode(F, se02);

figure('Name','Post-processed Result','NumberTitle','off'), imshow3D(F);

%% Area compute
%----------------------------------------------------------------------
b_area=0;
g_area=0;
gp_area=0;
for k=1:zdim
    b_area=b_area+bwarea(out_img(:,:,k));
    g_area=g_area+bwarea(J(:,:,k));
    gp_area=gp_area+bwarea(F(:,:,k));
end

b_vol=b_area*voxel_size(1)*voxel_size(2)*voxel_size(3)/1000;
g_vol=g_area*voxel_size(1)*voxel_size(2)*voxel_size(3)/1000;
gp_vol=gp_area*voxel_size(1)*voxel_size(2)*voxel_size(3)/1000;
den=g_area/b_area;
denp=gp_area/b_area;

str=sprintf('Breast volume = %.2f cc, Gland volume = %.2f(%.2f) cc, Density = %.3f(%.3f)', b_vol, g_vol, gp_vol,den,denp);
disp(str);

%% Area output
%----------------------------------------------------------------------
gland_area=F; 
breast_area=out_img;
fn=strcat(pathname,'gland.mat');
save(fn,'gland_area','breast_area');

%% 讀取手動乳腺區域
%----------------------------------------------------------------------
roi_directory = uigetdir();                   % uigetdir開啟檔案選取介面，選擇文件檔
roi_list = dir(roi_directory);                % listing = dir(name)指令可列出name這個文件檔中的物件名稱
roi_list=roi_list(3:size(roi_list),1);

fnum=numel(roi_list);                          % numel列出陣列元素個數
if (fnum<3)                                    % 當roi中檔案小於3時判斷為錯誤
        error('The folder is empty ???');
        return
end

m_gland=zeros(size(out_img));               % 先以size()提取出out_img的大小，zeros(n)創造n陣列大小的0
ref_slice=out_img(:,:,1);                   % 將z維設1，提取出x*y大小

for j = 1:length(roi_list) % loop through directory listing, but skip '.' and '..'
    
    full_path = fullfile(roi_directory, roi_list(j).name);  % 輸出完整filepath(path + filename)
    fileID = fopen(full_path,'rt');        % 指定以txt方式開啟檔案
    
    p_num=fscanf(fileID,'%d',1);           % 從txt檔中讀取總點數

    for i=1 : p_num                        
    p_x(i)=fscanf(fileID,'%d',1);          % 將每個點的x,y讀出存在p(i)中 
    p_y(i)=fscanf(fileID,'%d',1);
    end
    
    fclose(fileID);
    
    roi_BW = roipoly(ref_slice,p_x,p_y);    % 將每個點連起來，圈起來的部分反白

    slice_num=str2num(roi_list(j).name(2:3));   % 取出每個檔案檔名的第2到3個字元，並把他轉乘num格式
    
    m_gland(:,:,slice_num)=out_img(:,:,slice_num)&roi_BW;   %將m_gland設為乳房區域與手繪區域AND的結果
    
end

figure('Name','Manual Gland area','NumberTitle','off'), imshow3D(m_gland);

%% 計算SI indices
%----------------------------------------------------------------------
REF=sum(sum(sum(m_gland)));                       % REF(手繪)的體積
SEG=sum(sum(sum(gland_area)));                    % SEG(自動切割)的體積
IRS=sum(sum(sum(m_gland & gland_area)));          % 手繪與自動切割的交集
URS=sum(sum(sum(m_gland | gland_area)));          % 手繪與自動切割的聯集
For_EF=sum(sum(sum(~m_gland & gland_area)));

SI=2*IRS/(REF+SEG);                               % 計算各個數值 
OF=IRS/REF;
OV=IRS/URS;
EF=For_EF/REF;

disp('      SI         OF       OV        EF');
disp([SI OF OV EF]);
