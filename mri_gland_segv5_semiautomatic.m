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

% ���oDicom���Y���Ŷ���T�Apixel/mm
%----------------------------------------------------------------------
%extract size info from metadata (nobkpt)
voxel_size = [info.PixelSpacing; info.SliceThickness]';
disp(dicom_directory);

% Ū���ũаϰ�
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

%%��7x7x7 ���X�A���ؤl�I 
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

%%�T�w�ؤl�I�O�_���T
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
%%�`�NregionGrowing���ؤl�I�y�Ь�[x,y,z]
[poly, J] = regionGrowing(region_image, [new_x,new_y,new_z], 10); %, Inf, [], true, false); 
figure('Name','RegionGrowing Result','NumberTitle','off'), imshow3D(J);

%% image post-processing
%----------------------------------------------------------------------
% Open mask with disk�A�Ͻu�����
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

%% Ū����ʨŸ��ϰ�
%----------------------------------------------------------------------
roi_directory = uigetdir();                   % uigetdir�}���ɮ׿�������A��ܤ����
roi_list = dir(roi_directory);                % listing = dir(name)���O�i�C�Xname�o�Ӥ���ɤ�������W��
roi_list=roi_list(3:size(roi_list),1);

fnum=numel(roi_list);                          % numel�C�X�}�C�����Ӽ�
if (fnum<3)                                    % ��roi���ɮפp��3�ɧP�_�����~
        error('The folder is empty ???');
        return
end

m_gland=zeros(size(out_img));               % ���Hsize()�����Xout_img���j�p�Azeros(n)�гyn�}�C�j�p��0
ref_slice=out_img(:,:,1);                   % �Nz���]1�A�����Xx*y�j�p

for j = 1:length(roi_list) % loop through directory listing, but skip '.' and '..'
    
    full_path = fullfile(roi_directory, roi_list(j).name);  % ��X����filepath(path + filename)
    fileID = fopen(full_path,'rt');        % ���w�Htxt�覡�}���ɮ�
    
    p_num=fscanf(fileID,'%d',1);           % �qtxt�ɤ�Ū���`�I��

    for i=1 : p_num                        
    p_x(i)=fscanf(fileID,'%d',1);          % �N�C���I��x,yŪ�X�s�bp(i)�� 
    p_y(i)=fscanf(fileID,'%d',1);
    end
    
    fclose(fileID);
    
    roi_BW = roipoly(ref_slice,p_x,p_y);    % �N�C���I�s�_�ӡA��_�Ӫ������ϥ�

    slice_num=str2num(roi_list(j).name(2:3));   % ���X�C���ɮ��ɦW����2��3�Ӧr���A�ç�L�୼num�榡
    
    m_gland(:,:,slice_num)=out_img(:,:,slice_num)&roi_BW;   %�Nm_gland�]���ũаϰ�P��ø�ϰ�AND�����G
    
end

figure('Name','Manual Gland area','NumberTitle','off'), imshow3D(m_gland);

%% �p��SI indices
%----------------------------------------------------------------------
REF=sum(sum(sum(m_gland)));                       % REF(��ø)����n
SEG=sum(sum(sum(gland_area)));                    % SEG(�۰ʤ���)����n
IRS=sum(sum(sum(m_gland & gland_area)));          % ��ø�P�۰ʤ��Ϊ��涰
URS=sum(sum(sum(m_gland | gland_area)));          % ��ø�P�۰ʤ��Ϊ��p��
For_EF=sum(sum(sum(~m_gland & gland_area)));

SI=2*IRS/(REF+SEG);                               % �p��U�Ӽƭ� 
OF=IRS/REF;
OV=IRS/URS;
EF=For_EF/REF;

disp('      SI         OF       OV        EF');
disp([SI OF OV EF]);
