function Morder=ModelOrder(datain,wlen,woverlap)
%% 
% calculate the model order for the MVAR model
% INPUTS
% datain: matrix of channels by time samples
% wlen: window length (samples)
% woverlap: window overlapping (samples)
%        e.g.: fs=500Hz, 1s window with 50% overlap --> wlen=500
%        woverlap=250 (0.5*wlen)
% OUTPUT
% Morder=array containing the model order  
%

% Lorena Santamaria June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Divide the trial into windows
if size(datain,2)>=wlen 
    % there is more than 1 window
    windows = floor((size(datain,2)-woverlap )/(wlen-woverlap)); %no windows
    windowedData=zeros(size(datain,1),wlen,windows); % allocate memory
    for w =1:windows
        windowedData( :, :,w)=datain(:,(w-1 )*(wlen-woverlap)+(1:wlen));
    end
else
    % trial is shorter than the window length
    windows=1;
    windowedData=zeros(size(datain,1),size(datain,2),windows);
    windowedData(:,:,1)=datain;
end   
%% Calculate the model order for each window 
for  w=1:windows
    Morder(w)=optimalModelOrder(squeeze(windowedData(:,:,w)));
end