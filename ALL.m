clear all
close all
clc
subplot(4,1,1)
OOK(100000);
subplot(4,1,2)
PSK(100000);
subplot(4,1,3)
FSK(100000);
subplot(4,1,4)
QAM_AWGN(8,16,10000);
