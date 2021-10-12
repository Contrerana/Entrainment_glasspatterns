function PLV_masked=ApplyingPLVmask(PLVres,option)
% Applying the p values calculated with the PLV to each trial depending on
% the option selected that will be baseline corrected beforehand or not
% Inputs
    % PLVres: struct with PLV and p_values per trial. It also has
    % plv_baseline and p_baseline_values
% Output
    % PLVmasked: an array of trials by windows by ch by ch with the masked
    % connectivity values accordingly with option selected
%% get necessary parameters and allocate memory
p_th=0.050;
no_windows=size(PLVres(1).plv_original,1);
no_ch=size(PLVres(1).plv_original,2);
PLV_masked=zeros(length(PLVres),no_windows,no_ch,no_ch); % trials x windows x ch x ch
%% go through the different options

        
for tt=1:length(PLVres)
    % plv without masking
    PLV_original=PLVres(tt).plv_original;
    % plv p values to create plv-mask
    pvalues=PLVres(tt).p_values_plv;
    pvalues(pvalues>p_th)=NaN;
    % plv baseline
% % % %     PLV_basline=PLVres(tt).plv_baseOriginal;
    % plv p values to create baseline-mask
% % % %     pvalues_bas=PLVres(tt).p_values_base;
% % % %     pvalues_bas(pvalues_bas>p_th)=NaN;
    if option==1    % no baseline correction, PLV_original *p_mask_plv
        temp=PLV_original;temp(isnan(pvalues))=NaN;
        PLV_masked(tt,:,:,:)=temp;
    elseif option==2 % (PLV original- PLVbaseline)*p_mask_plv
        temp=PLV_original-repmat(PLV_basline,no_windows,1,1);
        temp(isnan(pvalues))=NaN;
        PLV_masked(tt,:,:,:,:)=temp;
    elseif option==3 % (PLV original- PLVbaseline*p_mask_baseline)*p_mask_plv
        bas=PLV_basline;bas(isnan(pvalues_bas))=NaN;%plv baseline masked
        temp=PLV_original-repmat(bas,no_windows,1,1); % plv baseline correction
        PLV_masked(tt,:,:,:,:)=temp;
    elseif option==4  % ((PLV_original-PLV_baseline)/PLV_baseline)*p_mask_plv
        temp=PLV_original-repmat(PLV_basline,no_windows,1,1);% ((PLV_original-PLV_baseline)
        temp=temp./repmat(PLV_basline,no_windows,1,1);%/PLV_baseline
        PLV_masked(tt,:,:,:,:)=temp;
    elseif option==5
        pvalues=PLVres(tt).p_values_plv;
        pmask=fdr_bh(pvalues); % same than option 2 but with p values fdr corrected
        pvalues=pvalues.*pmask;
        temp=PLV_original-repmat(PLV_basline,no_windows,1,1);
        temp(isnan(pvalues))=NaN;
        PLV_masked(tt,:,:,:,:)=temp;
    else
        msgbox('Wrong option','Error');
    end
end

            
          
        
   
        
   

