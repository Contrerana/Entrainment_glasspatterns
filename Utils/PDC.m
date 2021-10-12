function pdc=PDC(trial,p,wlength,woverlap,fmin,fmax,fs)
%% MVAR model
[~,A]=arfit(trial',p,p);
%% some constants
[nch,~,~] = size(A);
frange=fmin:fmax;
z = 1i*2*pi/fs;
H=zeros(nch,nch,length(frange));
denPDC=zeros(nch,nch,length(frange));
for n = 1 :length(frange) % Number of frequency points
    % A(f) matrix for PDC
    Af2=eye(nch) - reshape(sum(bsxfun(@times,reshape(A,nch*nch,p),...
        exp(-z*(1:p)*frange(n))),2),nch,nch);
    % H(f)=A-1(f) for DFT
    H(:,:,n) = inv(Af2);
    % normalized PDC
    for ch = 1 : nch
        denPDC(:,ch,n)=norm(Af2(:,ch));
    end
end
% normalised metrics
pdc=abs(Af2)./denPDC; %Aij/sqrt(aj'*aj)
% average freq info
pdc=squeeze(mean(pdc,3));
% main diagonal is zeros
pdc(logical(eye(size(pdc))))=0;
end
