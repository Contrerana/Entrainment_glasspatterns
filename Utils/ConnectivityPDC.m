function ConnectivityPDC(data,p_order,wlen,woverlap,fband1,fband2,SavingPath,ID,fs)
%Main function calling the important stuff
% Inputs: 
%        data: participant (matrix as channels by time by trials)
%        p_order: model order
%        wlength: window of interest (samples)
%        woverlap: overlapping window (samples)
%        frequency range [fband1 fband2]
%        SavingPath: to save results
%        ID: participant name (to name the results file)
%        fs=sampling frequency
% Output (file) 
%        PDCres is a struct with 3 fields
%             -Original PDC results
%             -Surrogate PDC results
%             - p values comparing Original vs Surrogate 
% Lorena Santamaria June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% constants
tic
nTrials=size(data,3);
num_perm=100;
%% memory preallocation
PDCres=struct();PDCres2=struct();
%% do things
for tt=1:nTrials
    fprintf('************* Trial %d out of %d \n\n',tt,nTrials);
    temp=squeeze(data(:,:,tt)); % channels by time points
    % calculate the original PDC
    pdc_original=PDCwindowing(temp,p_order,wlen,woverlap,fband1,fband2,fs);
    PDCres(tt).pdc_original=pdc_original;
    % calculate the surrogates PDC
    S_total=zeros(size(pdc_original));
    pdc_surr2=zeros(num_perm,size(pdc_original,1),size(pdc_original,2),size(pdc_original,3));
    %disp('Starting permutations');
    parfor iter=1:num_perm 
         surrData=ShufflingData(temp)';       
         pdc_surr=PDCwindowing(surrData,p_order,wlen,woverlap,fband1,fband2,fs);
         S=zeros(size(pdc_surr));
         %Check with original data
         C=bsxfun(@gt,pdc_surr,pdc_original);
         S(C)=1;
         S_total=S_total+S;
         % storage it
         pdc_surr2(iter,:,:,:)=pdc_surr;
    end   
    %disp('Ended permutations');
    % statistically relevant remain rest of channels zero
    p_values_pdc=S_total./num_perm;
    PDCres2(tt).pdc_surrogates=pdc_surr2;
    PDCres(tt).p_values_pdc=p_values_pdc;
    fprintf('************* Trial %d out of %d done \n\n',tt,nTrials);
end
toc
tic
%% save it
save([SavingPath 'PDC_' ID '_freq_' num2str(fband1) '_' num2str(fband2) '.mat'],'PDCres','-v7.3');
toc
%tic
%save([SavingPath 'PDC_' ID '_freq_' num2str(fband1) '_' num2str(fband2) '_surrogates.mat'],'PDCres2','-v7.3');  
%toc
end
