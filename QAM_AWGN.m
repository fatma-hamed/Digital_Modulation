function QAM_AWGN(M1,M2,N)
k1 = log2(M1);
N1 = N*k1;
data = randi([0 1],N1,1);
txSig = qammod(data,M1,'InputType','bit','UnitAveragePower',true);
max_snr = 30;
for snr = 1:max_snr
    
    rxSig = awgn(txSig,snr);
    
    
    rxData = qamdemod(rxSig,M1,'bin','OutputType','bit');
    
    BER(snr) = size(find(rxData-data),1)/N1;
    
end


semilogy(BER)
xlabel('SNR')
ylabel('BER in dB')
title('QAM AWGN')

hold on
k2 = log2(M2);

N2 = N*k2;


data = randi([0 1],N2,1);


txSig = qammod(data,M2,'InputType','bit','UnitAveragePower',true);


max_snr = 30;

for snr = 1:max_snr
    
    rxSig = awgn(txSig,snr);
    
    
    rxData = qamdemod(rxSig,M2,'bin','OutputType','bit');
    
    BER2(snr) = size(find(rxData-data),1)/N2;
    
end


semilogy(BER2)
xlabel('SNR')
ylabel('BER in dB')

L1 = ""+M1+'-QAM';
L2 = ""+M2+'-QAM';

legend(L1,L2)
end


