function p=optimalModelOrder(data)
%%
% adapated from eConnectome toolbox
% data is in the form of channels by time samples
% p is the best fit (minimum) between aike and bayessian methods
%
% Lorena Santamaria June 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ts = data';
[n, m]   = size(ts);     
fpe_error = [];
sbc_error = [];
j = 1;
for i = 2:10
    ne = n-i;
    npmax = m*i+1; 
    if (ne <= npmax)
        warndlg(['Time series too short or orders (should < ' num2str(i) ') too high!']);
        return;
    end
    [~,~,~,SBC,FPE] = arfit(ts,i,i);
    fpe_error(j) = real(FPE);
    sbc_error(j) = SBC;
    j = j+1;
end
[~,p_sbc]=min(sbc_error);p_sbc=p_sbc+1; %sum 1 as we start in 2 as min model order
[~,p_fpe]=min(fpe_error);p_fpe=p_fpe+1;
p=min(p_sbc,p_fpe);
% plot SBC and FPE curve
% figure;
% plot(2:20, sbc_error, 'color', 'b', 'LineWidth', 2);hold on;
% plot(2:20, fpe_error, 'color', 'r', 'LineWidth', 2);
% legend('SBC','FPE');title('1000 points window');
