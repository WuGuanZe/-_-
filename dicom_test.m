function varargout = dicom_test(varargin)
% dicom_test MATLAB code for dicom_test.fig
%      dicom_test, by itself, creates a new dicom_test or raises the existing
%      singleton*.
%
%      H = dicom_test returns the handle to a new dicom_test or the handle to
%      the existing singleton*.
%
%      dicom_test('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in dicom_test.M with the given input arguments.
%
%      dicom_test('Property','Value',...) creates a new dicom_test or raises the
%      existing singleton*.  Starting from the leftt, property value pairs are
%      applied to the GUI before dicom_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to dicom_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help dicom_test

% Last Modified by GUIDE v2.5 03-Mar-2016 12:55:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @dicom_test_OpeningFcn, ...
                   'gui_OutputFcn',  @dicom_test_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before dicom_test is made visible.
function dicom_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to dicom_test (see VARARGIN)

% Choose default command line output for dicom_test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes dicom_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = dicom_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
global dcm_list;
global dcm_num;
global PathName;
global oimg;
global k;
global left_42;
global right_42;
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
dcm_index=get(hObject,'Value');
dcm_index=round(dcm_index);
asd = num2str(dcm_index);
set(handles.text5, 'string',asd );

if dcm_index<1
    dcm_index=1;
end
if dcm_index>dcm_num
    dcm_index=dcm_num;
end


%dcm_list(dcm_index).name
fname = fullfile(PathName,dcm_list(dcm_index).name);
info = dicominfo(fname);
X= dicomread(info);
oimg= uint8(X/2);
set(handles.figure1,'CurrentAxes',handles.axes_org);
imshow(oimg);


%{

改這邊
rdcm_num = sprintf('%03d',dcm_index);
rname = fullfile(PathName,filename);
rinfo = imfinfo(rname);
Y = imread(rinfo);

%Y= dimread(rinfo);
%roimg= uint8(Y/2);

set(handles.figure1,'CurrentAxes',handles.axes_proc);
%Show_the_image(handles);
imshow(Y);

%}


set(handles.text6, 'string', fname); %file name
img_proc(handles);



%set(handles.figure1,'CurrentAxes',handles.axes_Horizontal);
Horizontal_Proj(handles);

%set(handles.figure1,'CurrentAxes',handles.axes_org);
Horizontal_line(handles);



%set(handles.figure1,'CurrentAxes',handles.axes_nounder);
nounder(handles);

%set(handles.figure1,'CurrentAxes',handles.axes_img_line);
img_nounder(handles);





%投影
%set(handles.figure1,'CurrentAxes',handles.axes_VerticalL);
Vertical_ProjL(handles);

%set(handles.figure1,'CurrentAxes',handles.axes_VerticalR);
Vertical_ProjR(handles);
%投影

%藍直線in小圖
%set(handles.figure1,'CurrentAxes',handles.axes_img_line);
Vertical_Biueline(handles)

%紅直線in小圖
%set(handles.figure1,'CurrentAxes',handles.axes_img_line);
Vertical_Redline(handles)

%藍直線in大圖
%set(handles.figure1,'CurrentAxes',handles.axes_org);
Vertical_Biueline(handles)

%紅直線in大圖
%set(handles.figure1,'CurrentAxes',handles.axes_org);
Vertical_Redline(handles)

%set(handles.figure1,'CurrentAxes',handles.black_block);
Black_Blocks(handles)

%set(handles.figure1,'CurrentAxes',handles.Contour_white);
Contour_white(handles)

%set(handles.figure1,'CurrentAxes',handles.Contour_colored);
Contour_colored(handles)


set(handles.figure1,'CurrentAxes',handles.axes_proc); %handles.Finish
Finish(handles)


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global PathName;
global dcm_list;
global dcm_num;
global oimg;
global bbb;
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PathName = uigetdir;
%cd(PathName);

for i=0:9
t_list = dir(fullfile(PathName,strcat(num2str(i),'*')));
[t_num,n] =  size(t_list);
if t_num>1
dcm_list=t_list;    
[dcm_num,n] =  size(dcm_list);
end
end

% n_min=str2num(get(handles.edit1, 'string'));
% n_max=str2num(get(handles.edit2, 'string'));
set(handles.slider1,'Min', 0);
set(handles.edit1, 'string', '0');
set(handles.slider1,'Max', dcm_num);
set(handles.edit2, 'string', num2str(dcm_num));
x=1/dcm_num;
y=x*10;
set(handles. slider1,'SliderStep', [x y]);

fname = fullfile(PathName,dcm_list(1).name);
info = dicominfo(fname)
X= dicomread(info);
oimg= uint8(X/2);
set(handles.figure1,'CurrentAxes',handles.axes_org);
imshow(oimg);
info = dicominfo(fname);

set(handles.text6, 'string', fname);
img_proc(handles);


    

% --- Executes on key press with focus on slider1 and none of its controls.
function slider1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over slider1.
function slider1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.
function pushbutton1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes_org_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes_org (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%{
先拔掉看看
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
global h;
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h = imrect;
%position = wait(h);
%}
%{
先拔掉看看
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global h;
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos = round(getPosition(h))
%}


% --- Executes on scroll wheel click while the figure is in focus.
function figure1_WindowScrollWheelFcn(hObject, eventdata, handles)
global dcm_num;
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	VerticalScrollCount: signed integer indicating direction and number of clicks
%	VerticalScrollAmount: number of lines scrolled for each click
% handles    structure with handles and user data (see GUIDATA)
loc_index=get(handles.slider1,'Value');
if eventdata.VerticalScrollCount > 0
    if loc_index<dcm_num
        set(handles.slider1,'Value', loc_index+1);
        slider1_Callback(handles.slider1, eventdata, handles);
    end
else
    if loc_index>0
        set(handles.slider1,'Value', loc_index-1);
        slider1_Callback(handles.slider1, eventdata, handles);
    end
end
  

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)

% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

function img_proc(handles)
global oimg;
global BW3;
global BW2;
global bbb;
global num_for_change;
O = im2double(oimg);
A = anisodiff(O, 5, 50, .25, 1);

BW = im2bw(A, 0.2); %改前0.4
num_from_BW = size(BW);
num_for_change = max(num_from_BW);
% level = graythresh(A)
% BW = im2bw(A,level);

%Perform a morphological operation on the image.
se = strel('disk',3);
se2 = strel('disk',15); %改前是10 
% 
BW2=BW;
%BW2 = imclose(BW,se);
%BW2 = bwmorph(BW2,'fill',Inf);
BW2 = imfill(BW2,'holes');
%BW2 = bwareaopen(BW2, 50);

CC = bwconncomp(BW2);
numPixels = cellfun(@numel,CC.PixelIdxList);
[B,I] = sort(numPixels, 'descend');
%[biggest,idx] = max(numPixels);  
BW2(:,:)=0;
BW2(CC.PixelIdxList{I(1)}) = 1;

B(2);
if B(2)>3000 
BW2(CC.PixelIdxList{I(2)}) = 1;
end
BW3 = imclose(BW2,se2);
set(handles.figure1,'CurrentAxes',handles.axes_proc);
imshow(oimg);

%{ 
    hold on
        contour(bbb,[0 0],'r');
        h = findobj('Type','patch');
        set(h,'LineWidth',3)
    hold off
%}


function  Horizontal_Proj(handles)  % I: The name of image 
global oimg;
global Hproj;
m=0;
n=0;
[m,n]= size(oimg);
Hproj=zeros(m,1);

for h=1:m
    Hproj(h) = sum(oimg(h,:));  
end;

H1 = plot(Hproj,1:m);


function  Horizontal_line(handles)  % I: The name of image 
global oimg;
global Hproj;
global Hval;
global num_for_change;

[Hmax Hval] = max(Hproj);



if Hval < 250;
    Hval = 250;
end


hold on
Hproj_x=[0 num_for_change];
Hproj_y=[Hval Hval];
plot(Hproj_x,Hproj_y,'LineWidth',3,'Color','blue');
hold off

function  nounder(handles)  % I: The name of image 
global oimg;
global Hval;
global inHval;
global nounder;
global BW3;
global num_for_change;
global nounder_fix;
global ex;
%inHval = Hval;
se = strel('disk',20);
nounder = imcrop(BW3,[0 0 num_for_change Hval]);
nounder_fix = imclose(nounder,se);
%nounder_fix = imopen(nounder,se);
%nounder_fix = imfill(nounder,4,'holes');  
imshow(ex)%黑白
    
   


function  img_nounder(handles)  % I: The name of image 
global oimg;
global Hval;
global oimg_nounder;
global BW3;
global inHval;
global num_for_change;
global ex;
global nounder_fix;
inHval = Hval+5;  %20

oimg_nounder = imcrop(BW3,[0 0 num_for_change Hval]);
ex = imcrop(oimg,[0 0 num_for_change Hval]);

imshow(nounder_fix)%原圖


function  Vertical_ProjL(handles)  % I: The name of image 
global nounder;
global Vproj_2L;
global num_for_change;
m=0;
n=0;
[m,n]= size(nounder);
Vproj=zeros(1,n);

for v=1:n
    Vproj(v) = sum(nounder(:,v));  
end;
Vproj_2L = medfilt1(Vproj,200)+50;

for num=3:num_for_change
    if Vproj_2L(num-2) > Vproj_2L(num-1) && Vproj_2L(num-1)==Vproj_2L(num);
        Vproj_2L(num-1) = 1;
       
    end
end

V1 = plot(1:n,Vproj_2L);

function  Vertical_ProjR(handles)  % I: The name of image 
global nounder;
global Vproj_2R;
global num_for_change;

m=0;
n=0;
[m,n]= size(nounder);
Vproj=zeros(1,n);

for v=1:n
    Vproj(v) = sum(nounder(:,v));  
end;
Vproj_2R = medfilt1(Vproj,200)+50;




for num=3:num_for_change
    if Vproj_2R(num-2) == Vproj_2R(num-1) && Vproj_2R(num-1)<Vproj_2R(num);
        Vproj_2R(num-1) = 1;
        
    end
end



V2 = plot(1:n,Vproj_2R);

function  Vertical_Biueline(handles)  % I: The name of image 
global oimg;
global Vproj;
global Vproj_2L;
global Epikhigh;
global Ohbago;
global Babaoice;
global num_for_change;
for num=3:num_for_change
    if Vproj_2L(num-2) > Vproj_2L(num-1) && Vproj_2L(num-1)==Vproj_2L(num);
        Vproj_2L(num-1) = 1;
        
       
    end
end


 ind = find(Vproj_2L==1);
 ind_length = length(ind);
  
 
 
 x1 =[Epikhigh Epikhigh];
 y1 = [0 num_for_change];
 
 x2 =[ind(ind_length) ind(ind_length)] ;
 y2 =[0 num_for_change]; 
 
 
 Epikhigh = ind(1);  %藍線1
 Ohbago = ind(ind_length);%藍線2
 
  if Epikhigh>256
     Epikhigh= 200;
  end
 
 if Ohbago <Babaoice
     Ohbago = num_for_change;
 end
 
 hold on
 plot(x1,y1,'LineWidth',3,'Color','blue')%左邊
 plot(x2,y2,'LineWidth',3,'Color','blue')%右邊
%plot(x3,y3,'LineWidth',3,'Color','green')%中間
 hold off

hold off

function  Vertical_Redline(handles)  % I: The name of image 
global oimg;
global Vproj;
global Vproj_2R;
global Fantacy;
global Babaoice;
global num_for_change;
for num=3:num_for_change
    if Vproj_2R(num-2) == Vproj_2R(num-1) && Vproj_2R(num-1)<Vproj_2R(num);
        Vproj_2R(num-1) = 1;
        
    end
end
 ind = find(Vproj_2R==1);

 ind_length = length(ind);
  
 
 
 Fantacy = ind(1);  %紅線1
 Babaoice = ind(ind_length);%紅線2 
 
  if Babaoice <256
     Babaoice = 320;
 end
 x1 =[ind(1) ind(1)];
 y1 = [0 num_for_change];
 
 x2 =[Babaoice Babaoice] ;
 y2 =[0 num_for_change]; 
hold on
 plot(x1,y1,'LineWidth',3,'Color','red')%左
plot(x2,y2,'LineWidth',3,'Color','red')%右
hold off
%{ 
錯誤的經驗
[Vmin Vvalmin] = min(Vproj_2R);
[Vmax Vvalmax] = max(Vproj_2R);

hold on
Vprojmin_x=[Vvalmin Vvalmin];
Vprojmin_y=[0 512];

Vprojmax_x=[Vvalmax Vvalmax];
Vprojmax_y=[0 512];
plot(Vprojmin_x,Vprojmin_y,'LineWidth',3,'Color','red')
plot(Vprojmax_x,Vprojmax_y,'LineWidth',3,'Color','red')

plot(ind,'o','MarkerFaceColor','r','MarkerSize',10);
hold off

hold on
Vproj_x=[VP1 VP1]
Vproj_y=[0 512]
plot(Vproj_x,Vproj_y,'LineWidth',3,'Color','blue')

Vproj_x2=[VP2 VP2]
Vproj_y2=[0 512]
plot(Vproj_x2,Vproj_y2,'LineWidth',3,'Color','red')

%}

function  Black_Blocks(handles)  % I: The name of image 
global oimg_nounder;
global Epikhigh;%藍1
global Ohbago;%藍2
global Fantacy;%紅1
global Babaoice;%紅2
global inHval;
global Hval;
global oimg;%要留著，要不然在切換的時候可能會跑不出來
global bbb;
global  i;
global ccc;
global num_for_change;
global nounder_fix;
global left_end;
global right_end;
global left_mid_fix;
global right_mid_fix;
global ggg;


left_num = nounder_fix(:,Epikhigh);
right_num = nounder_fix(:,Babaoice);
left_h = sum(left_num);
right_h = sum(right_num);
left_end = Hval-left_h;
right_end = Hval-right_h ;
left_mid = (Fantacy + Epikhigh)/2;
left_mid_fix = round(left_mid);
right_mid = (Babaoice+Ohbago)/2;
right_mid_fix = round(right_mid);



 for x = 1:Hval
        for y = 1:Fantacy
            if nounder_fix(x,y) ~=0
                nounder_fix(x,y) =0;
                aaa = nounder_fix;
            end
        end
 end
 
 

 
 

 
 for x = 1:Hval
        for y = Epikhigh:Babaoice
            if nounder_fix(x,y) ~=0
                nounder_fix(x,y) =0;
                aaa = nounder_fix;
            end
        end
 end
 

 for x = 1:Hval
        for y = Ohbago:num_for_change
            if nounder_fix(x,y) ~=0
                nounder_fix(x,y) =0;
                aaa = nounder_fix;
            end
        end
 end
 
 
 bbb = im2bw(aaa);
 
 ccc = bwmorph(bbb,'remove',Inf);
 i = imdilate(ccc,ones(5));
 %imshow(bbb)
 
  %x1 =[ind(1) ind(1)];  fill
 %y1 = [0 num_for_change];
 
 
 x1 =[Epikhigh Fantacy Epikhigh Epikhigh]; 
 y1 =[left_end Hval Hval left_end];
 
 ddd = roipoly(bbb,x1,y1);
 eee = and(bbb,not(ddd));
 
 
 x2 =[Babaoice Ohbago Babaoice Babaoice]; 
 y2 =[right_end Hval Hval right_end] ;
 fff = roipoly(bbb,x2,y2);
 ggg = and(eee,not(fff));
 
 imshow(ggg)
 
 


 

function  Contour_white(handles)  % I: The name of image 
global bbb;
global  i;
global ccc;

 ccc = bwmorph(bbb,'remove',Inf);
 i = imdilate(ccc,ones(5));
 imshow(i)
 
 function  Contour_colored(handles)  % I: The name of image 
global bbb;
global  i;
global ccc;
global ggg;
 ccc = bwmorph(ggg,'remove',Inf);
 i = imdilate(ccc,ones(5));
 imshow(i)
 
 
    hold on
        contour(ggg,[0 0],'g');
        
        h = findobj('Type','patch');
        set(h,'LineWidth',3)
    hold off
 
 
function  Show_the_image(handles)  % I: The name of image 
global PathName;
global dcm_index;
global  i;
global ccc;

if dcm_index==1
    imshow('001.jpg')
end
    
 function  Finish(handles)  % I: The name of image 
global oimg;
global bbb;
global  i;
global ccc;

global ggg;
 ccc = bwmorph(ggg,'remove',Inf);
 i = imdilate(ccc,ones(5));
 imshow(oimg)
 


    hold on

        contour(ccc,[0 0],'g');
        h = findobj('Type','patch');
        set(h,'LineWidth',2)
    hold off

%{    
function  Count_Left(handles)  % I: The name of image 
global bbb;
global inHval;
global left;
global left_42;
left = 0;
lll = 0.625*0.625;
for x = 1:inHval
    for y = 1:256
        if bbb(x,y) == 1
            left=left+1;
        end
    end
end
left_42 = left*lll;
left_42; %顯示數字
%}
%{
function  Count_Left_All(handles)  % I: The name of image 
global left_42;
global left_total;
global dcm_num;

left_total = 0;


for i = 1:dcm_num
    left_total =left_total + left_42;
end
left_total;
  %}

%{
function  Count_Right(handles)  % I: The name of image 
global bbb;
global inHval;
global right;
global right_42;
right = 0;
rrr = 0.625*0.625;

for x = 1:inHval
    for y = 256:512
        if bbb(x,y) == 1
            right=right+1;
        end
    end
end
right_42 = right*rrr;
right_42; %顯示數字
%}

% --------------------------------------------------------------------
function Coordinate_Callback(hObject, eventdata, handles)
% hObject    handle to Coordinate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X11
global Y11
[a,b] = ginput(1);
X11=round(a);
Y11=round(b);
% 
% if(X11>240||X11<0)
%     X11=0
% end
% if(Y11>128||Y11<0)
%     Y11=0
% end
set(handles.edit6, 'string', num2str(X11));
set(handles.edit7, 'string', num2str(Y11));



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Region_growing_Callback(hObject, eventdata, handles)
% hObject    handle to Region_growing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global X11
global Y11
global i

J = regiongrowing(i,X11,Y11,0.2); 
imshow(i+J);
guidata(hObject,handles);



function left_Callback(hObject, eventdata, handles)
% hObject    handle to leftt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of leftt as text
%        str2double(get(hObject,'String')) returns contents of leftt as a double


% --- Executes during object creation, after setting all properties.
function leftt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function right_Callback(hObject, eventdata, handles)
% hObject    handle to rightt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rightt as text
%        str2double(get(hObject,'String')) returns contents of rightt as a double


% --- Executes during object creation, after setting all properties.
function rightt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%{
function counting(handles)
global dcm_num; 
%}


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function openfile_Callback(hObject, eventdata, handles)
% hObject    handle to openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global PathName;
global dcm_list;
global dcm_num;
global oimg;
global num_for_change;
global Epikhigh;%藍1
global Ohbago;%藍2
global Fantacy;%紅1
global Babaoice;%紅2
%{
global bbb;
global k;
global oimg_nounder;
global Epikhigh;%藍1
global Ohbago;%藍2
global Fantacy;%紅1
global Babaoice;%紅2
global Hval;
global  i;
global ccc;
global nounder_fix;
global left_end;
global right_end;
global left_mid_fix;
global right_mid_fix;
global ggg;
%}
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tic;
PathName = uigetdir;
%cd(PathName);

for i=0:9
t_list = dir(fullfile(PathName,strcat(num2str(i),'*')));
[t_num,n] =  size(t_list);
if t_num>1
dcm_list=t_list;    
[dcm_num,n] =  size(dcm_list);
end
end

% n_min=str2num(get(handles.edit1, 'string'));
% n_max=str2num(get(handles.edit2, 'string'));
set(handles.slider1,'Min', 0);
set(handles.edit1, 'string', '0');
set(handles.slider1,'Max', dcm_num);
set(handles.edit2, 'string', num2str(dcm_num));
x=1/dcm_num;
y=x*10;
set(handles. slider1,'SliderStep', [x y]);

fname = fullfile(PathName,dcm_list(1).name);
info = dicominfo(fname)
X= dicomread(info);
oimg= uint8(X/2);
set(handles.figure1,'CurrentAxes',handles.axes_org);
imshow(oimg);
info = dicominfo(fname);
%set(handles.figure1,'CurrentAxes',handles.axes_proc);
%imshow(oimg);
set(handles.text6, 'string', fname);
img_proc(handles);


ni= 3*0.625*0.625;
left = 0;
left_array = [];

right = 0;
right_array = [];


for f = 1:dcm_num
    k = num2str(f,'%03d');
    l = [PathName,'\',k,'.dcm'];
    
    x =dicomread(l);
    oimg= uint8(x/2);
    %imshow(oimg)


O = im2double(oimg);
A = anisodiff(O, 5, 50, .25, 1);

BW = im2bw(A, 0.2); %改前0.4  0.2
% level = graythresh(A)
% BW = im2bw(A,level);
%Perform a morphological operation on the image.
se = strel('disk',3);
se2 = strel('disk',15);
se3 = strel('disk',20);%改前是10   15
% 
BW2=BW;
%BW2 = imclose(BW,se);
%BW2 = bwmorph(BW2,'fill',Inf);
BW2 = imfill(BW2,'holes');
%BW2 = bwareaopen(BW2, 50);

CC = bwconncomp(BW2);
numPixels = cellfun(@numel,CC.PixelIdxList);
[B,I] = sort(numPixels, 'descend');
%[biggest,idx] = max(numPixels);
BW2(:,:)=0;
BW2(CC.PixelIdxList{I(1)}) = 1;

[m,n]=size(I);


if n>1
B(2);
    if B(2)>3000 
        BW2(CC.PixelIdxList{I(2)}) = 1;
    end
end

BW3 = imclose(BW2,se2);
%set(handles.figure1,'CurrentAxes',handles.axes_proc);
%imshow(BW3);


%%
%水平投影
m=0;
n=0;
[m,n]= size(oimg);
Hproj=zeros(m,1);

for h=1:m
    Hproj(h) = sum(oimg(h,:));  
end;

%H1 = plot(Hproj,1:m);
%imshow(H1)

[Hmax Hval] = max(Hproj);

if Hval < 250;
    Hval = 250;
end

%{
hold on
Hproj_x=[0 512]
Hproj_y=[Hval Hval]
plot(Hproj_x,Hproj_y,'LineWidth',3,'Color','blue');
hold off
%}
%%
%切除下面


nounder = imcrop(BW3,[0 0 num_for_change Hval]);
nounder_fix = imclose(nounder,se3);

%imshow(nounder)
%%
%
m=0;
n=0;
[m,n]= size(nounder);
Vproj=zeros(1,n);

for v=1:n
    Vproj(v) = sum(nounder(:,v));  
end;
Vproj_2L = medfilt1(Vproj,200)+50;

for num=3:num_for_change
    if Vproj_2L(num-2) > Vproj_2L(num-1) && Vproj_2L(num-1)==Vproj_2L(num);
        Vproj_2L(num-1) = 1;
       
    end
end

%V1 = plot(1:n,Vproj_2L);

%%
%
m=0;
n=0;
[m,n]= size(nounder);
Vproj=zeros(1,n);

for v=1:n
    Vproj(v) = sum(nounder(:,v));  
end;
Vproj_2R = medfilt1(Vproj,200)+50;




for num=3:num_for_change
    if Vproj_2R(num-2) == Vproj_2R(num-1) && Vproj_2R(num-1)<Vproj_2R(num);
        Vproj_2R(num-1) = 1;
        
    end
end



%V2 = plot(1:n,Vproj_2R);

%%
%
for num=3:num_for_change
    if Vproj_2L(num-2) > Vproj_2L(num-1) && Vproj_2L(num-1)==Vproj_2L(num);
        Vproj_2L(num-1) = 1;
        
       
    end
end


 ind = find(Vproj_2L==1);
 ind_length = length(ind);
 

 
 %x1 =[Epikhigh Epikhigh];
 %y1 = [0 num_for_change];
 
 %x2 =[ind(ind_length) ind(ind_length)] ;
 %y2 =[0 num_for_change]; 
 
 
 Epikhigh = ind(1);  %藍線1
 Ohbago = ind(ind_length);%藍線2
 
  if Epikhigh>256
     Epikhigh= 200;
  end
 
 if Ohbago <Babaoice
     Ohbago = num_for_change;
 end
 %{
 hold on
 plot(x1,y1,'LineWidth',3,'Color','blue')%左邊
 plot(x2,y2,'LineWidth',3,'Color','blue')%右邊
%plot(x3,y3,'LineWidth',3,'Color','green')%中間
 hold off
 %}
 
 %%
 %
 for num=3:num_for_change
    if Vproj_2R(num-2) == Vproj_2R(num-1) && Vproj_2R(num-1)<Vproj_2R(num);
        Vproj_2R(num-1) = 1;
        
    end
end
 ind = find(Vproj_2R==1);
 ind_length = length(ind);
  

 
 Fantacy = ind(1);  %紅線1
 Babaoice = ind(ind_length);%紅線2 
 
 
  if Babaoice <256
     Babaoice = 320;
 end
 %x1 =[ind(1) ind(1)];
 %y1 = [0 num_for_change];
 
 %x2 =[Babaoice Babaoice] ;
 %y2 =[0 num_for_change]; 
%{
 hold on
 plot(x1,y1,'LineWidth',3,'Color','red')%左
plot(x2,y2,'LineWidth',3,'Color','red')%右
hold off
 %}
% 

%%
%

left_num = nounder_fix(:,Epikhigh);
right_num = nounder_fix(:,Babaoice);
left_h = sum(left_num);
right_h = sum(right_num);
left_end = Hval-left_h;
right_end = Hval-right_h ;
left_mid = (Fantacy + Epikhigh)/2;
left_mid_fix = round(left_mid);
right_mid = (Babaoice+Ohbago)/2;
right_mid_fix = round(right_mid);

 for x = 1:Hval
        for y = 1:Fantacy
            if nounder_fix(x,y) ~=0
                nounder_fix(x,y) =0;
                aaa = nounder_fix;
            end
        end
 end
 
 
 for x = 1:Hval
        for y = Epikhigh:Babaoice
            if nounder_fix(x,y) ~=0
                nounder_fix(x,y) =0;
                aaa = nounder_fix;
            end
        end
 end
 

 for x = 1:Hval
        for y = Ohbago:num_for_change
            if nounder_fix(x,y) ~=0
                nounder_fix(x,y) =0;
                aaa = nounder_fix;
            end
        end
 end
 
 
% bbb = im2bw(aaa);  %???
bbb = aaa; 
 kk = size(bbb);
 oo = min(kk);
 
 for x = 1:oo
     for y = 1:Epikhigh
         if bbb(x,y) ==1
         left = left+1;
         %left_array(i) = left;
         left;
         end
     end
 end
 
 
 for x = 1 : oo
        for y = Babaoice : num_for_change
            
            if bbb(x,y) == 1
                
                right = right +1;
                %right_array(i) = right;
                right;
                
            end
        end
 end
 

 xx1 =[Fantacy Epikhigh Epikhigh Fantacy Fantacy]; 
 yy1 =[Hval left_end left_end+10 Hval+30 Hval];
    
 dddd = roipoly(BW3,xx1,yy1);
eeee = and(BW3,dddd);
% imshow(bbb)
 
xx2 =[Babaoice Babaoice Ohbago Ohbago Babaoice]; 
yy2 =[right_end right_end+10 Hval+30 Hval right_end] ;
gggg = roipoly(BW3,xx2,yy2);
ffff = and(BW3,gggg);

hhhh = or(eeee,ffff);

 %%
 
  %set(handles.figure1,'CurrentAxes',handles.axes_org);
 
 x1 =[Epikhigh Fantacy Epikhigh Epikhigh]; 
 y1 =[left_end Hval Hval left_end];
 
 ddd = roipoly(bbb,x1,y1);
 eee = and(bbb,not(ddd));
 
 
 x2 =[Babaoice Ohbago Babaoice Babaoice]; 
 y2 =[right_end Hval Hval right_end] ;
 fff = roipoly(bbb,x2,y2);
 ggg = and(eee,not(fff));
 %hhh = and(ggg,BW2);
 
  
 %ccc = bwmorph(ggg,'remove',Inf);
 %i = imdilate(ccc,ones(5));

 
  
 ggg(num_for_change,num_for_change)=0; %bbb下面補零
 DaHyun = or(ggg,hhhh);
 
 %figure(f),imshow(ggg);
 [m,n]= size(oimg);
 for i=1:m
     for j=1:n
 re_img(i,j,f)=DaHyun(i,j);
     end
 end
 %figure(f),imshow(DaHyun,'border','tight','initialmagnification','fit');  
 %set (gcf,'Position',[0,0,num_for_change,Hval]);  %比較用
 %set (gcf,'Position',[0,0,640,640]); %原本的  num_for_change
  %h = gcf;
  % g = figure('Visible','off');
%{
    hold on
        contour(DaHyun,[0 0],'r');
        h = findobj('Type','patch');
        set(h,'LineWidth',2)
    hold off
%}

  %a = getframe(gcf);
  %imwrite(a,'.bmp')
    
    %saveas(gcf,fullfile(PathName,k),'bmp');
    %close(gcf);
end    
left_finish = left*ni;
left_last = round(left_finish);
right_finish = right*ni;
right_last = round(right_finish);

unit = ' c.c.';
ll = num2str(left_last);
rr = num2str(right_last);
total_left_last = [ll unit];
total_right_last = [rr unit];
set(handles.leftt, 'string', total_left_last);
set(handles.rightt, 'string', total_right_last);
size(re_img)
save('breast_area.mat','re_img');
figure('Name','Breast area Image','NumberTitle','off'), imshow3D(re_img);
toc;
% --------------------------------------------------------------------
function functionnnn_Callback(hObject, eventdata, handles)
% hObject    handle to functionnnn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function V_Projection_Callback(hObject, eventdata, handles)
% hObject    handle to V_Projection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global nounder;
global Vproj_2L;
global Vproj_2R;
global bigone;
m=0;
n=0;
[m,n]= size(nounder);
Vproj=zeros(1,n);

for v=1:n
    Vproj(v) = sum(nounder(:,v));  
end;
Vproj_2L = medfilt1(Vproj,200)+50;

for num=3:bigone
    if Vproj_2L(num-2) > Vproj_2L(num-1) && Vproj_2L(num-1)==Vproj_2L(num);
        Vproj_2L(num-1) = 1;
       
    end
end
figure
V1 = plot(1:n,Vproj_2L);
%subplot(211),plot(1:n,Vproj_2L);
title('垂直投影(左)');


q=0;
r=0;
[q,r]= size(nounder);
Vproj=zeros(1,r);

for v=1:r
    Vproj(v) = sum(nounder(:,v));  
end;
Vproj_2R = medfilt1(Vproj,200)+50;




for num=3:bigone
    if Vproj_2R(num-2) == Vproj_2R(num-1) && Vproj_2R(num-1)<Vproj_2R(num);
        Vproj_2R(num-1) = 1;
        
    end
end


figure
V2 = plot(1:r,Vproj_2R);
%subplot(212),plot(1:r,Vproj_2R);
title('垂直投影(右)');


% --------------------------------------------------------------------
function H_Projection_Callback(hObject, eventdata, handles)
% hObject    handle to H_Projection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global oimg;
global Hproj;
m=0;
n=0;
[m,n]= size(oimg);
Hproj=zeros(m,1);

for h=1:m
    Hproj(h) = sum(oimg(h,:));  
end;
figure
H1 = plot(Hproj,1:m);
title('水平投影');


% --------------------------------------------------------------------
function rough_breast_area_Callback(hObject, eventdata, handles)
% hObject    handle to rough_breast_area (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global oimg;
global Hval;
global oimg_nounder;
global BW3;
global inHval;
global bigone;
inHval = Hval+20;

oimg_nounder = imcrop(BW3,[0 0 bigone inHval]);
ex = imcrop(oimg,[0 0 bigone inHval]);
figure
imshow(ex)
title('rough breast area');


% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[sfilename ,sfilepath]=uiputfile({'*.jpg';'*.bmp';'*.tif';'*.*'},'儲存圖片','untitled.jpg');
if ~isequal([sfilename,sfilepath],[0,0])
sfilefullname=[sfilepath ,sfilename];
imwrite(handles.axes_proc,sfilefullname);
else
end


% --------------------------------------------------------------------
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
close all;
close(gcf);
clear;
