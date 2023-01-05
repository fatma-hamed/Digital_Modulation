function FSK(N)
Bin_SeqF = (randi([0 1],1,N));
P_signalF = 1 ;
max_SNR = 30;
ModF = zeros(1,N); 
DModF = zeros(1,N);
BERF = zeros(1,max_SNR);
BER_tF = zeros(1,max_SNR);
noiseF = [];
RxF = [];
%--------------Modulation-----------------
for i = 1:N
    if Bin_SeqF(i) ==1
        ModF(i) = 1;
    else
        ModF(i) = j;
    end
end
%--------------Channel coding-------------
channelcoding3 = repelem(ModF,3);
channelcoding6 = repelem(ModF,6);
%----------- Transmision -----------------
for i = 1:max_SNR
    p_noise = P_signalF ./ (2*(10.^ (i/10)));
    noiseF = sqrt(p_noise) .* [randn(1,N)+j*randn(1,N)];
    RxF = ModF + noiseF;
    noise_channelcoding3 = sqrt(p_noise) .* [randn(1,length(channelcoding3))+j*randn(1,length(channelcoding3))];
    decoded3 = channelcoding3 + noise_channelcoding3;
    decoded3 = reshape(decoded3,[3,N]).';
    decoded3 = floor(sum(decoded3,2)).';
    decoded3(find(real(decoded3)>=imag(decoded3)))=1;
    decoded3(find(real(decoded3)<imag(decoded3)))=0;
    noise_channelcoding6 = sqrt(p_noise) .* [randn(1,length(channelcoding6))+j*randn(1,length(channelcoding6))];
    decoded6 = channelcoding6 + noise_channelcoding6;
    decoded6 = reshape(decoded6,[6,N]).';
    decoded6 = floor(sum(decoded6,2)).';
    decoded6(find(real(decoded6)>=imag(decoded6)))=1;
    decoded6(find(real(decoded6)<imag(decoded6)))=0;
    BER_channel_coding6(i) = sum(abs(decoded6 - Bin_SeqF))/N;
    BER_channel_coding3(i) = sum(abs(decoded3 - Bin_SeqF))/N;
    %------------ Demodulation ----------
    for k = 1:N
        if real(RxF(k)) > imag(RxF(k))
            RxF(k) = 1;
        else
            RxF(k) = 0;
        end
    end
    BERF(i) = sum(abs(RxF - Bin_SeqF))/N;
    BER_tF(i) = (1/2)*erfc(sqrt(10^(i/10)/2));
end
%figure()
plot([1:1:30],BERF)
% semilogy(BERF)
xlabel('SNR(dB)')
ylabel('BER')
title("BFSK Modulation")
hold on 
plot([1:1:30],BER_tF,'black')
hold on 
plot([1:30],BER_channel_coding3,'red')
% semilogy(BER_channel_coding3)
hold on 
plot([1:30],BER_channel_coding6,'green')
legend('Practical BER','Theoritical BER','BER with channel coding 3 repitition','BER with channel coding 6 repitition')
% semilogy(BER_tF)
end