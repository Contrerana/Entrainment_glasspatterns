function plv=PLVtrial(trial,wlen,woverlap)
% calculates the PLV values per trial 
% inputs:
    % trial= arary of channels by time points
    % wlen = size of the window of interest (samples)
    % woverlap= how much overlapp (samples)
    % [fmin,fmax]=frequency range
    % fs== sampling frequency
% outputs
    % PLV result
%
% Lorena Santamaria July 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[nCh,~]=size(trial);
% perfom hilber transform
htemp=hilbert(trial);
% windowing part
winHtemp=windowing(htemp,wlen,woverlap);
% proper PLV
angles=angle(winHtemp);
plv=zeros(size(angles,3),nCh,nCh);
if size(angles,3)==1
    % there is only a window
    for ii=1:nCh
        ch1=squeeze(angles(ii,:));
        parfor jj=ii:nCh
            ch2=squeeze(angles(jj,:));
            diff=ch1-ch2;
            tempPLV(ii,jj)=abs(mean(exp(1i*diff),2)); 
        end
    end
    tempp=tempPLV+tempPLV.';% we make symmetric (a to b = b to a)
    tempp(logical(eye(size(tempp))))=0; %diagonal to zeros
    plv(1,:,:)=tempp; 
else
    % wo do the same per each window
    for w=1:size(angles,3)
        tempPLV=zeros(nCh,nCh);
        for ii=1:nCh
            ch1=squeeze(angles(ii,:,w));
            parfor jj=ii:nCh
                ch2=squeeze(angles(jj,:,w));
                diff=ch1-ch2;
                tempPLV(ii,jj)=abs(mean(exp(1i*diff),2));
            end
        end
        tempPLV(logical(eye(size(tempPLV))))=0; %diagonal to zeros
        plv(w,:,:)=tempPLV+tempPLV.'; % we make symmetric (a to b = b to a)
    end
end