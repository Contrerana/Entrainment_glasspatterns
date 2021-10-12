function dataShuff=ShufflingData(data)
[N,L]=size(data);
Y=fft(data,[],2); % Get spectrum
% Add random phase shifts (negative for conjugates), preserve DC offset
rnd_theta= -pi + (2*pi).*rand(N,L/2-1); 
Y(:,2:L/2)=Y(:,2:L/2).*exp(1i*rnd_theta);
Y(:,L/2+2:L)=Y(:,L/2+2:L).*exp(-1i*flip(rnd_theta,2));
% return phase-randomized data
newdata=ifft(Y,[],2);
dataShuff=newdata';
%figure;plot(data2(:,j));grid on;hold on;plot(dataShuff(j,:),'r');
end