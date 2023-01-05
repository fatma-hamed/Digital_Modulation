function PSK(N)
seq = (randi([0 1],1,N));
p_signal = 1 ;
max_snr = 30;
detected = zeros(1,N);
BER_vector = zeros(1,max_snr);
BERt = zeros(1,max_snr); %theoritical Bit Error Rate
BER_channel_coding6 = zeros(1,max_snr);
BER_channel_coding3 = zeros(1,max_snr);
%------- Channel coding using repetition code ------------
channelcoding3 = repelem(seq,3)*2-1;
channelcoding6 = repelem(seq,6)*2-1;
%---------- Modulation and Demodulation ------------------
for snr = 1:max_snr
    p_noise = p_signal ./ (2*(10.^ (snr/10)));
    noise = sqrt(p_noise) .* [randn(1,N)+j*randn(1,N)];
    %Modulation
    modulated = (seq * 2 )-1;
    %Adding channel effect 
    received = modulated + noise ;
    %Demodulation
    ctr = 0 ;
    for i = 1:N
       if real(received(i)) > 0
           detected(i) = 1;
       else 
           detected(i) = 0;
       end
       
       if detected(i) ~= seq(i)
          ctr = ctr + 1;
       end
    end    
    noise_channelcoding3 = sqrt(p_noise) .* [randn(1,length(channelcoding3))+j*randn(1,length(channelcoding3))];
    decoded3 = real(channelcoding3 + noise_channelcoding3);
    decoded3 = reshape(decoded3,[3,N]).';
    decoded3 = floor(sum(decoded3,2)).';
    decoded3(find(decoded3>=0))=1;
    decoded3(find(decoded3<0))=0;
    noise_channelcoding6 = sqrt(p_noise) .* [randn(1,length(channelcoding6))+j*randn(1,length(channelcoding6))];
    decoded6 = real(channelcoding6 + noise_channelcoding6);
    decoded6 = reshape(decoded6,[6,N]).';
    decoded6 = floor(sum(decoded6,2)).';
    decoded6(find(decoded6>=0))=1;
    decoded6(find(decoded6<0))=0;
    BER_channel_coding6(snr) = sum(abs(decoded6 - seq))/N;
    BER_channel_coding3(snr) = sum(abs(decoded3 - seq))/N;
    BER_vector(snr) = ctr / N ; 
    BERt(snr) = (1/2)*erfc(sqrt(2*10^(snr/10)/(2)));  

end
%figure()
plot([1:max_snr],BER_vector)
% semilogy(BER_vector)
xlabel('SNR(dB)')
ylabel('BER')
title('PSK modulation')
hold on
plot([1:max_snr],BERt,'black')
% semilogy(BERt)
hold on 
plot([1:max_snr],BER_channel_coding3,'red')
% semilogy(BER_channel_coding3)
hold on 
plot([1:max_snr],BER_channel_coding6,'green')
legend('Practical BER','Theoritical BER','BER with channel coding 3 repitition','BER with channel coding 6 repitition')
% semilogy(BER_channel_coding6)
end
