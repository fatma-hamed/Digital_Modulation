clear all
close all
clc



N = 10^5;

seq = (randi([0 1],1,N) * 2 )-1;


p_signal = sum(seq.^2)/N ;


max_snr = 30;
detected = zeros(1,N);
BER_vector = zeros(1,max_snr);


for snr = 1:max_snr


%--------------- channel effect ---------------
    p_noise = p_signal * 10 ^ (-snr/10);
    
    noise = sqrt(p_noise) * randn(1,N);
    BERt = zeros(1,max_snr);
    received = seq + noise ;
    
    ctr = 0 ;
    for i = 1:N
       if received(i) > 0
           detected(i) = 1;
       else 
           detected(i) = -1;
       end
       
       if detected(i) ~= seq(i)
          ctr = ctr + 1;
       end
    end
    
    
   BER_vector(snr) = ctr / N ; 
   BERt(snr) = (1/2)*erfc(sqrt(2*10^(snr/10)/(2)));
    

end





plot([1:1:30],BER_vector)
xlabel('SNR(dB)')
ylabel('BER')
hold on
plot([1:1:30],BERt)