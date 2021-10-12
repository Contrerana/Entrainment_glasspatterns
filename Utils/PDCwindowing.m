function pdc=PDCwindowing(trial,p,wlen,woverlap,fmin,fmax,fs)
%% windowing first
windowedData=windowing(trial,wlen,woverlap);
%% connectivity for each window later
windows=size(windowedData,3);
pdc=zeros(windows,size(trial,1),size(trial,1));
for w=1:windows
    if windows==1
        data=windowedData(:,:);
    else
        data=squeeze(windowedData(:,:,w));
    end
    pdc(w,:,:)=pdcReal(data,fs,p,fmin,fmax);
end



end
