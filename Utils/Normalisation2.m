function dataout=Normalisation2(datain,option)
%% zscore of the data
% inputs: 
%     data:3D matrix as channels by time points by trials
%     option: type of normalisation 
%             1: zscore of each trial individually
%             2: zscore of the whole trials together
%             3: zscore of 
%             3: baseline zscore
%             4: zscore of each window
% Lorena June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sz=size(datain);dataout=zeros(sz);
switch option
    
    case 1
        for ii=1:sz(3)
            temp=squeeze(datain(:,:,ii));  %ch by time points
            temp2=zscore(temp); % zscore of each time point
            dataout(:,:,ii)=temp2;
        end
    case 2
        for ii=1:sz(1)
            temp=squeeze(datain(ii,:,:));  %time points by trials
            temp2=zscore(temp'); 
            dataout(ii,:,:)=temp2'; 
        end
    case 3
        dataout=zscore(datain,0,[2 3]); %time and trials
    case 4
        dataout=zscore(datain,0,'all'); % all, ch time and trials
    otherwise
        dataout=datain;
end
