clear all
close all
clc
N = 100000;
M1 = 8;
M2 = 16;
k1 = log2(M1);
N1 = N*k1;
data = randi([0 1],N1,1);
txSig = qammod(data,M1,'InputType','bit','UnitAveragePower',true);
max_snr = 30;
for snr = 1:max_snr
    p_noise = 1 ./ (2*(10.^ (snr/10)));
    noise = sqrt(p_noise) .* [randn(1,N)+j*randn(1,N)];
    rxSig = txSig + noise.';
    
    rxData = qamdemod(rxSig,M1,'bin','OutputType','bit');
    
    BER(snr) = sum(abs(rxData - data))/(N1;
end


semilogy(BER)
xlabel('SNR')
ylabel('BER in dB')
title('QAM AWGN')

% hold on
% k2 = log2(M2);
% 
% N2 = N*k2;
% 
% 
% data = randi([0 1],N2,1);
% 
% 
% txSig = qammod(data,M2,'InputType','bit','UnitAveragePower',true);
% 
% 
% max_snr = 30;
% for snr = 1:max_snr
%     
%     rxSig = awgn(txSig,snr);
%     
%     
%     rxData = qamdemod(rxSig,M2,'bin','OutputType','bit');
%     
%     BER2(snr) = size(find(rxData-data),1)/N2;
% end
% 
% 
% semilogy(BER2)
% xlabel('SNR')
% ylabel('BER in dB')
% 
% L1 = ""+M1+'-QAM';
% L2 = ""+M2+'-QAM';
% legend(L1,L2)