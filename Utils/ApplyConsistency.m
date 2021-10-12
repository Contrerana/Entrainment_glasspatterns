function PLV_masked_th=ApplyConsistency(PLV_masked,trials_th)
% Apply a threshold accross trials
% if a link is not present in trials_th of the total no of trials that link
% is considered noisy and set to NaN (or 0) accordingly
% Inputs:
      % PLV_msaked: array of trials x window x ch x ch with the
      % connectivity values already apply the p_mask 
      % trials_th: number indicating the threshold to apply (e.g.: 0.3, aka
      % link is present at least in 30% of the trials).
%% counting no times link appeared accross trials
cont=[];
no_windows=size(PLV_masked,2);
for w=1:no_windows
    temp=squeeze(PLV_masked(:,w,:,:));
    temp2=squeeze(sum(temp>0));
    cont(w,:,:)=temp2./size(temp,1);
end
cont(cont<trials_th)=0;
% apply threshold
PLV_masked_th=zeros(size(PLV_masked));
for tr=1:size(PLV_masked,1)
    temp=squeeze(PLV_masked(tr,:,:,:));
    temp(~cont)=NaN;
    PLV_masked_th(tr,:,:,:)=temp;
end
