function [Mout,newlabels]=RearangeByRegions(Min,labels)
% Re arrange channels from F-FC-C-CP-P-PO-O
% Inputs
%   Min: array to re-organise on the shape of channels by channel
%   labels: channel labels, numel(labels)=size(Min,1)=size(Min,2)
% Ouputs
%  Mout: re-organised array of channels by channels
% Lorena Santamaria Sep 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% findout each region channels
Fchannels=cellfun(@(x) strcmp(x(1),'F'),labels) & cellfun(@(x) ~strcmp(x(2),'C'),labels) ;
FCch=cellfun(@(x) strcmp(x(1),'F'),labels) & cellfun(@(x) strcmp(x(2),'C'),labels) ;
Cchannels=cellfun(@(x) strcmp(x(1),'C'),labels) & cellfun(@(x) ~strcmp(x(2),'P'),labels) ;
CPch=cellfun(@(x) strcmp(x(1),'C'),labels) & cellfun(@(x) strcmp(x(2),'P'),labels) ;
Pchannels=cellfun(@(x) strcmp(x(1),'P'),labels) & cellfun(@(x) ~strcmp(x(2),'O'),labels) ;
POch=cellfun(@(x) strcmp(x(1),'P'),labels) & cellfun(@(x) strcmp(x(2),'O'),labels) ;
Och=cellfun(@(x) strcmp(x(1),'O'),labels);
%% re-arange labels
newlabels=[sort(labels(Fchannels));sort(labels(FCch));sort(labels(Cchannels));...
    sort(labels(CPch));sort(labels(Pchannels));sort(labels(POch));sort(labels(Och))];
% find the former position
[~,out2]=ismember(newlabels,labels);
%% re-argange matrix
Mout=zeros(size(Min));
for r=1:numel(labels)
    for c=1:numel(labels)
        Mout(r,c)=Min(out2(r),out2(c));
    end
end