close all;
clc;

%% ----------------------------------------Parameter Setup----------------------------------------

reps = 1000000; %repititions for each bit
Ts = 1/reps; %sampling time in seconds
Fs = 1/Ts; %sampling frequency in Hz
T = 1; %Bit duration in seconds

%% ------------------------------------------Message----------------------------------------------

message_bits = [1 0 1 1 0 1 1 0 1 0 1 0 1 1 1 0 1 0 1 0 0 1 0 0 0 0 1 0 1 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1 0 1 1 0];

%% ---------------------------------------BPSK System---------------------------------------------

%range of snr 
snrDB = 0:0.1:10; %signal to noise ratio in DB

bit_err = [];

%sending the message bits into the system for different values of snr  
for i = 1:length(snrDB)
    
    snrDB_now = snrDB(i); %signal to noise ratio for this iteration
    [received_bits , message_with_reps] = bpskSystem(message_bits,snrDB_now,reps); %received bits for this iteration    
    
    bit_err = [bit_err errorCheck(received_bits,message_with_reps)]; %error calculation for this iteration
    
end

%% --------------------------------Theoretical Bit Error Rate-------------------------------------
snr = 10.^(snrDB./10); %snr in linear scale
theoretical_BER = qfunc(sqrt(2*snr)); %using q function to get probability of error for a given SNR

%% ----------------------------------------Plotting-----------------------------------------------

figure(1);

%Empirical plot
semilogy(snrDB,bit_err,'-o');
grid on;
hold on;

%Theoretical plot
semilogy(snrDB,theoretical_BER);
title("Bit Error Rate");
ylabel("Error");
xlabel("SNR");
legend("Empirical","Theoretical");
