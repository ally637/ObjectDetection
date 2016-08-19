function varargout = ObjectDetection(varargin)
% ObjectDetection MATLAB code for ObjectDetection.fig
%      ObjectDetection, by itself, creates a new ObjectDetection or raises the existing
%      singleton*.
%
%      H = ObjectDetection returns the handle to a new ObjectDetection or the handle to
%      the existing singleton*.
%
%      ObjectDetection('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ObjectDetection.M with the given input arguments.
%
%      ObjectDetection('Property','Value',...) creates a new ObjectDetection or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ObjectDetection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ObjectDetection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ObjectDetection

% Last Modified by GUIDE v2.5 19-Aug-2016 14:44:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ObjectDetection_OpeningFcn, ...
                   'gui_OutputFcn',  @ObjectDetection_OutputFcn, ...
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


% --- Executes just before ObjectDetection is made visible.
function ObjectDetection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ObjectDetection (see VARARGIN)

% Choose default command line output for ObjectDetection
handles.output = hObject;



%Create tab group
%uitab.BackgroundColor = [.5 .5 .5];
handles.tgroup = uitabgroup('Parent', handles.figure1);
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', ...
    '                                          Training                                          ');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', ...
    '                                          Testing                                          ');


%Place panels into each tab
set(handles.P1,'Parent',handles.tab1)
set(handles.P2,'Parent',handles.tab2)

%Reposition each panel to same location as panel 1
set(handles.P2,'position',get(handles.P1,'position'));

% Setup UI
% Browse Icon
browse_icon = imread('browse_icon.jpg');
browse_icon = imresize(browse_icon, [25 25]);
set(handles.load_images_browse,'cdata',browse_icon);
set(handles.testing_load_image_browse,'cdata',browse_icon);
set(handles.load_model_btn,'cdata',browse_icon);

set(handles.train_btn,'Enable','off');
set(handles.load_images_btn,'Enable','on');

% Setup SIFT
run('vlfeat-0.9.20\toolbox\vl_setup');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ObjectDetection wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ObjectDetection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_images_btn.
function load_images_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_images_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rootfolder = get(handles.load_images_edit,'String');

imgSets = imageSet(rootfolder,'recursive');
handles.imgSets = imgSets;
guidata(hObject,handles);

for i = 1:size(imgSets,2)
    
    categoryName = imgSets(1,i).Description;
    imageCount = imgSets(1,i).Count;
    string_to_disp = sprintf('%s%s %s%s   %s%s',num2str(i),'. ',categoryName,': ',num2str(imageCount),' training images');
    set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        string_to_disp));
end

 set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        'Images Loaded Successfully!!!',handles.line_in_msgdisp));
set(hObject,'Enable','off');
index = size(get(handles.Message_disp,'String'), 1);
set(handles.Message_disp,'Value',index);
set(handles.train_btn,'Enable','on');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function load_images_edit_Callback(hObject, eventdata, handles)
% hObject    handle to load_images_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of load_images_edit as text
%        str2double(get(hObject,'String')) returns contents of load_images_edit as a double


% --- Executes during object creation, after setting all properties.
function load_images_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to load_images_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Display default location in load_images_edit_text_box
rootfolder = fullfile(pwd,'objectCategories');
% handles.load_images_edit = 'Default';
set(hObject,'String',rootfolder);
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_images_browse.
function load_images_browse_Callback(hObject, eventdata, handles)
% hObject    handle to load_images_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

folder_name = uigetdir(pwd,'Select folder with various Object Categories');
set(handles.load_images_edit,'String',folder_name);
set(handles.load_images_btn,'Enable','on');

set(handles.Message_disp,'String',strvcat('Object Detection',handles.line_in_msgdisp));


function train_edit_Callback(hObject, eventdata, handles)
% hObject    handle to train_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of train_edit as text
%        str2double(get(hObject,'String')) returns contents of train_edit as a double


% --- Executes during object creation, after setting all properties.
function train_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to train_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in train_btn.
function train_btn_Callback(hObject, eventdata, handles)
% hObject    handle to train_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


set(handles.animation_sift,'Backgroundcolor','y');
set(handles.animation_kmeans,'Backgroundcolor','y');
set(handles.animation_bow,'Backgroundcolor','y');
set(handles.animation_svm,'Backgroundcolor','y');

% SIFT started...
no_of_category = length(handles.imgSets);

for i=1:no_of_category
    no_of_images = length(handles.imgSets(:,i).ImageLocation);
    
    str1 = sprintf('%s %s%s %s','Image Category',num2str(i),':',handles.imgSets(:,i).Description);
    str2 = sprintf('No. of images = %4d',no_of_images);
    strn = ' ';
    
    drawnow
     set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        strn,str1,str2));
    stry = get(handles.Message_disp,'String');

    str3 = sprintf('Extracting SIFT features...\t %4d/%4d',1,no_of_images);
    for j=1:no_of_images
        str3 = sprintf(strcat(str3(1:29),'%4d/%4d'),j,no_of_images);
        
        file_path = char(handles.imgSets(1,i).ImageLocation(1,j));
        [pathstr,name,ext] = fileparts(file_path);
        descriptor = features_SIFT(file_path);
        save(char(strcat(pathstr,'\',name,'.mat')),'descriptor');
    
        drawnow
        set(handles.Message_disp,'String', ...
        strvcat(stry, ...
        str3));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);
    end
    
    
end


% variables ========
features_each = [];
features_category = [];
features_all = [];
% ==================
no_of_category = length(handles.imgSets);
count = 0;
for i=1:no_of_category
    no_of_images = length(handles.imgSets(:,i).ImageLocation);
    
    for j=1:no_of_images
        file_path = char(handles.imgSets(1,i).ImageLocation(1,j));
        [pathstr,name,ext] = fileparts(file_path);
        load(char(strcat(pathstr,'\',name,'.mat')),'descriptor');
        descriptor = double(descriptor)/255;
        features_all = [features_all; descriptor];
        count = count + size(descriptor,1);
        features_each = [features_each; count];
    end
    features_category = [features_category; count];
end

set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        ' ','Total number of features extracted: ',num2str(count)));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);

drawnow
  set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        ' ','SIFT features extracted successfully!!',handles.line_in_msgdisp));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);

% SIFT ended

drawnow
set(handles.animation_sift,'Backgroundcolor','g');
drawnow


% kmeans started

clusters = 500;
iteration = 100;

set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        'Starting K Means Clustering...', ...
        'This might take 1 or 2 minutes depending on your processor',' '));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);
drawnow
        
        
% using library

[centers, dist_n_val] = vl_kmeans(features_all',clusters);
dist_n_val = double(dist_n_val');
for i = 2:(clusters+2)
dist_n_val(:,i)=dist_n_val(:,1);
end
centers = centers';
% ======================
% without using library
% [centers, dist_n_val] = kmeans(features_all, clusters, iteration);
% =========================
set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        'Done With K Means Clustering!!',handles.line_in_msgdisp));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);
drawnow

% kmeans ended

set(handles.animation_kmeans,'Backgroundcolor','g');

drawnow
% bow started

set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        'Creating Bag Of Visual Words...', ...
       ' '));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);
drawnow

img_cnt = 1;
img_each = 0;
category_cnt = 1;
histogram = zeros(1,clusters);

for i=1:size(features_all,1)
    
    location = dist_n_val(i,clusters+1);
    histogram(1,location) = histogram(1,location) + 1;
    if(i == features_each(img_cnt,1))
        histogram = histogram/norm(histogram);
        file_path = char(handles.imgSets(1,category_cnt).ImageLocation(1,img_cnt-img_each));
        [pathstr,name,ext] = fileparts(file_path);
        save(char(strcat(pathstr,'\histograms\',name,'hist.mat')),'histogram');
        
        
        if(i == features_category(category_cnt,1))
            img_each = img_cnt;
            category_cnt = category_cnt + 1;
        end
        
        img_cnt = img_cnt + 1;
        histogram = zeros(1,clusters);
        
    end
    
end

set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        'Bag of Visual Words Created!!',handles.line_in_msgdisp));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);
drawnow


% bow ended

set(handles.animation_bow,'Backgroundcolor','g');

drawnow
% svm started

X = []; % stores the features
Y = []; % stores the category
Z = []; % stores the names
    
for i=1:size(handles.imgSets,2)
    
    for j = 1:handles.imgSets(1,i).Count
        file_path = char(handles.imgSets(1,i).ImageLocation(1,j));
        [pathstr,name,ext] = fileparts(file_path);
        load(char(strcat(pathstr,'\histograms\',name,'hist.mat')),'histogram');
        X = [X; histogram];
        Y = [Y; i];
        
    end
    
    
    
    Z = [Z; {handles.imgSets(1,i).Description}];
end

file_path = fullfile('objectCategories','reinf_histogram.mat');
if exist(file_path,'file')
    load('objectCategories\reinf_histogram');
    
    X = [X; reinf_histogram{1,1}];
    Y = [Y; reinf_histogram{1,2}];
end


trained_models = {};
for i = 1:size(Z,1)
    
    set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        sprintf('%s%s%s','Training for ',handles.imgSets(1,i).Description,' ...')));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);
drawnow

    
    Y_new = Y;
    
    Y_new(Y_new ~= i) = 0;
    Y_new(Y_new == i) = 1;
    
    C = 0.1; sigma = 0.1;
    model = svmTrain(X, Y_new, C, @(x1,x2) gaussianKernel(x1,x2, sigma));

    [p,q] = svmPredict(model, X);
    
    trained_models{i} = struct('model',model, ...
                         'name',Z(i));
    fprintf('Training Accuracy: %f\n', mean(double(p == Y_new)) * 100);
end
 set(handles.Message_disp,'String', ...
        strvcat(get(handles.Message_disp,'String'), ...
        'Successfully Trained!!!',handles.line_in_msgdisp,' ',...
        'Now, Start testing the image by going to "Testing" tab',' '));
        index = size(get(handles.Message_disp,'String'), 1);
        set(handles.Message_disp,'Value',index);
drawnow

% svm ended

set(handles.animation_svm,'Backgroundcolor','g');
drawnow
        
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function testing_load_image_text_Callback(hObject, eventdata, handles)
% hObject    handle to testing_load_image_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of testing_load_image_text as text
%        str2double(get(hObject,'String')) returns contents of testing_load_image_text as a double


% --- Executes during object creation, after setting all properties.
function testing_load_image_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to testing_load_image_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in testing_load_image_browse.
function testing_load_image_browse_Callback(hObject, eventdata, handles)
% hObject    handle to testing_load_image_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider_brightness_Callback(hObject, eventdata, handles)
% hObject    handle to slider_brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_brightness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to slider_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider_contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit_brightness_Callback(hObject, eventdata, handles)
% hObject    handle to edit_brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_brightness as text
%        str2double(get(hObject,'String')) returns contents of edit_brightness as a double


% --- Executes during object creation, after setting all properties.
function edit_brightness_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_brightness (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_contrast_Callback(hObject, eventdata, handles)
% hObject    handle to edit_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_contrast as text
%        str2double(get(hObject,'String')) returns contents of edit_contrast as a double


% --- Executes during object creation, after setting all properties.
function edit_contrast_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_contrast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on button press in Detect_image.
function Detect_image_Callback(hObject, eventdata, handles)
% hObject    handle to Detect_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1



function load_model_edit_Callback(hObject, eventdata, handles)
% hObject    handle to load_model_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of load_model_edit as text
%        str2double(get(hObject,'String')) returns contents of load_model_edit as a double


% --- Executes during object creation, after setting all properties.
function load_model_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to load_model_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in load_model_btn.
function load_model_btn_Callback(hObject, eventdata, handles)
% hObject    handle to load_model_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Reinforce.
function Reinforce_Callback(hObject, eventdata, handles)
% hObject    handle to Reinforce (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in correct_btn.
function correct_btn_Callback(hObject, eventdata, handles)
% hObject    handle to correct_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function Message_disp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Message_disp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Set global variables
line_in_msgdisp = '----------------------------------------------------------------------------------------------';
handles.line_in_msgdisp = line_in_msgdisp;
guidata(hObject,handles);


set(hObject,'String',strvcat('Object Detection',handles.line_in_msgdisp));
index = size(get(hObject,'String'), 1);
set(hObject,'Value',index);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes during object creation, after setting all properties.
function load_images_browse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to load_images_browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
