%% PLV CONNECTIVITY ANALYSIS
%
%
% Lorena Santamaria July 2021
%% set-up
pwd;current_folder=pwd;
addpath(genpath(current_folder));
SavingPath=fullfile(current_folder,'Connectivity_PLV/Results44ch/zscore1/');
Folders=dir(fullfile(current_folder,'preprocessedData'));
disp(size(Folders));
Folders(1:2)=[]; % find out participants folders
Folders={Folders.name}'; %subjects folder names
%% fixed parameters
fs=1000;
wlength=1*fs;
woverlap=0.5*wlength;
outlineElc=[58,51,50,37,36,29,28,14,13,12,11,2,1]; % 48 channles left
outlineElc2=[58,55,54,53,52,51,50,37,36,29,28,14,13,12,11,2,1]; % 44 channels left 

%% get files (should be 4)
eegfiles=dir(fullfile(current_folder,'preprocessedData',Folders{pt},'*.mat'));
eegfiles={eegfiles.name}';
Folder=Folders{pt};
Nfil=numel(eegfiles);
for ff=1:numel(eegfiles)
    disp('loading file');
    %load the file (matrix on the shape of ch by time by trials)
    eegclean=load(fullfile(current_folder,'preprocessedData',Folder,eegfiles{ff}));    
    disp('loaded');
    % get the data
    namef=fieldnames(eegclean);
    data=getfield(eegclean,namef{1});
    % eliminate the last 2 electrodes (EOG)
    if size(data,1)==63
        data=data(1:end-2,:,:);
    end
    % eliminate "external" electrodes
    data(outlineElc2,:,:)=[];
    % normalisation
    dataN=Normalisation2(data,1);
    % get the frequency band
    fband1=str2double(extractBetween(eegfiles{ff},'lp','hp'));
    fband2=str2double(extractBetween(eegfiles{ff},'hp','.mat'));
    % get the ID
    ID=extractBefore(eegfiles{ff},'_eegData');
    fprintf('Calculating connectivity participant %s file %s, number %d out of 4. \n\n',ID,eegfiles{ff},ff);
    disp('****************************************************************');
    ConnectivityPLV2(dataN,wlength,woverlap,fband1,fband2,SavingPath,ID);    
end