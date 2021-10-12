function ConnectivityPLV2(dataN,wlen,woverlap,fband1,fband2,SavingPath,ID)
%Main function calling the important stuff
% Inputs: 
%        data: participant (matrix as channels by time by trials)
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
nTrials=size(dataN,3);
num_perm=100;

%% memory preallocation
PLVres=struct();%PDCres2=struct();
%% do things
for tt=1:nTrials
    fprintf('************* Trial %d out of %d \n\n',tt,nTrials);
    temp=squeeze(dataN(:,:,tt)); % channels by time points
    % calculate the original PLV
    plv_original=PLVtrial(temp,wlen,woverlap);
    PLVres(tt).plv_original=plv_original; %storage it
    % calculate the surrogates PLV
    S_total=zeros(size(plv_original));
    parfor iter=1:num_perm 
         surrData=ShufflingData(temp)';       
         plv_surr=PLVtrial(surrData,wlen,woverlap);
         S=zeros(size(plv_surr));
         %Check with original data
         C=bsxfun(@gt,plv_surr,plv_original);S(C)=1;
         S_total=S_total+S; %keep track to calculate p values later
    end   
    % statistically relevant remain rest of channels zero
    p_values_plv=S_total./num_perm;
    PLVres(tt).p_values_plv=p_values_plv;
    fprintf('************* Trial %d out of %d done \n\n',tt,nTrials);
end
toc
%% save it
save([SavingPath 'PLV_' ID '_freq_' num2str(fband1) '_' num2str(fband2) '.mat'],'PLVres','-v7.3');
fprintf('File: PLV_%s_freq_%d_%d.mat is saved\n\n',ID,fband1,fband2);
end
