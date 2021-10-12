function ConnectivityPLV(dataN,wlen,woverlap,fband1,fband2,SavingPath,ID)
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
% % % %     temp2=temp(:,1:500);
    % calculate the original PLV
    plv_original=PLVtrial(temp,wlen,woverlap);
% % % %     plv_baseline=PLVtrial(temp2,500,0);
    PLVres(tt).plv_original=plv_original;
    PLVres(tt).plv_baseOriginal=plv_baseline;
    % calculate the surrogates PLV
    S_total=zeros(size(plv_original));
% % % %     S_total_base=zeros(size(plv_baseline));
    %plv_surr2=zeros(num_perm,size(plv_original,1),size(plv_original,2),size(plv_original,3));
    parfor iter=1:num_perm 
         surrData=ShufflingData(temp)';       
         plv_surr=PLVtrial(surrData,wlen,woverlap);
% % % %          plv_surr_base=PLVtrial(ShufflingData(temp2)',500,0);
         S=zeros(size(plv_surr));
% % % %          S1=zeros(size(plv_surr_base));
         %Check with original data
         C=bsxfun(@gt,plv_surr,plv_original);S(C)=1;
% % % %          C=bsxfun(@gt,plv_surr_base,plv_baseline);S1(C)=1;
         S_total=S_total+S;
% % % %          S_total_base=S_total_base+S1;
    end   
    % statistically relevant remain rest of channels zero
    p_values_plv=S_total./num_perm;
% % % %     p_values_base=S_total_base./num_perm;
    PLVres(tt).p_values_plv=p_values_plv;
%     PLVres(tt).p_values_base=p_values_base;
    fprintf('************* Trial %d out of %d done \n\n',tt,nTrials);
end
toc
% tic
%% save it
save([SavingPath 'PLV_' ID '_freq_' num2str(fband1) '_' num2str(fband2) '.mat'],'PLVres','-v7.3');
% toc
%tic
%save([SavingPath 'PDC_' ID '_freq_' num2str(fband1) '_' num2str(fband2) '_surrogates.mat'],'PDCres2','-v7.3');  
%toc
end
