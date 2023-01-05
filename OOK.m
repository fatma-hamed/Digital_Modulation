function OOK(N)
A = 1;
Bin_Seq = (randi([0 1],1,N));
max_SNR = 30;
Mod = zeros(1,N); 
DMod = zeros(1,N);
BER = zeros(1,max_SNR);
BERt = zeros(1,max_SNR);
BER_channel_coding6 = zeros(1,max_SNR);
BER_channel_coding3 = zeros(1,max_SNR);
%------- Channel coding using repetition code ------------
channelcoding3 = repelem(Bin_Seq,3);
channelcoding6 = repelem(Bin_Seq,6);
%-------------------------------------------------------
Rx = [];
for i = 1:N
    if Bin_Seq(i) ==1
        Mod(i) = A;
    end
end
P_signal = 1 ;
T = (A+0)/2;
for i = 1:max_SNR
    p_noise = P_signal ./ (2*(10.^ (i/10)));
    noise = sqrt(p_noise) .* [randn(1,N)+j*randn(1,N)];
    Rx = Mod + noise;
    for k = 1:N
        if real(Rx(k)) > T
           Rx(k) = 1;
        else
            Rx(k)= 0;
        end
    end
    noise_channelcoding3 = sqrt(p_noise) .* [randn(1,length(channelcoding3))+j*randn(1,length(channelcoding3))];
    decoded3 = real(channelcoding3 + noise_channelcoding3);
    decoded3 = reshape(decoded3,[3,N]).';
    decoded3 = floor(sum(decoded3,2)).';
    decoded3(find(decoded3<2.0))=0;
    decoded3(find(decoded3>=2.0))=1;
    noise_channelcoding6 = sqrt(p_noise) .* [randn(1,length(channelcoding6))+j*randn(1,length(channelcoding6))];
    decoded6 = real(channelcoding6 + noise_channelcoding6);
    decoded6 = reshape(decoded6,[6,N]).';
    decoded6 = floor(sum(decoded6,2)).';
    decoded6(find(decoded6<4.0))=0;
    decoded6(find(decoded6>=4.0))=1;
    BER_channel_coding6(i) = sum(abs(decoded6 - Bin_Seq))/N;
    BER_channel_coding3(i) = sum(abs(decoded3 - Bin_Seq))/N;
    BER(i) = sum(abs(Rx - Bin_Seq))/N;
    BERt(i) = (1/2)*erfc(sqrt(10^(i/10)/(2*2)));
end
%figure()
plot([1:1:max_SNR],BER,'green')
xlabel('SNR(dB)')
ylabel('BER')
title("OOK Modulation")
hold on
plot([1:1:max_SNR],BER_channel_coding3,'red')
hold on
plot([1:1:max_SNR],BER_channel_coding6)
hold on 
plot([1:1:max_SNR],BERt,'black') 
legend('Practical BER','Theoritical BER','BER with channel coding 3 repitition','BER with channel coding 6 repitition')
end