function windowedData=windowing(trial,wlen,woverlap)
% divide each trial into windows of wlen legth 
% Inputs: 
%        trial: channels by time points
%        wlength: window of interest (samples)
%        woverlap: overlapping window (samples)
% Output 
%       windowed data: channels by time by windows
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lorena Santamaria June 2021
if size(trial,2)>=wlen
    % more than 1 window
    windows = floor((size(trial,2)-woverlap )/(wlen-woverlap));
    windowedData=zeros(size(trial,1),wlen,windows);
    for w =1:windows
        windowedData( :, :,w)=trial(:,(w-1 )*(wlen-woverlap)+(1:wlen));
    end
else
    % not enough for more than 1
    windows=1;
    windowedData=zeros(size(trial,1),size(trial,2),windows);
    windowedData(:,:,1)=trial;
end
