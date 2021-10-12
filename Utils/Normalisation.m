function dataout=Normalisation(datain)
%% zscore of the data
% input: 3D matrix as channels by time points by trials
%
% Lorena June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sz=size(datain);dataout=zeros(sz);
for ii=1:sz(3)
    temp=squeeze(datain(:,:,ii));  %ch by time points
    temp2=zscore(temp); % zscore of the whole trial
    dataout(:,:,ii)=temp2;
end