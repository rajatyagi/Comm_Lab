close all;
clc;

%% ----------------------------------------Parameter Setup----------------------------------------

reps = 100000; %repititions for each symbol
Ts = 1/reps; %sampling time in seconds
Fs = 1/Ts; %sampling frequency in Hz
T = 1; %Bit duration in seconds
Label_format = 'Gray'; %Labelling Format

%% ------------------------------------------Message----------------------------------------------

message_bits = [1 0 1 1 0 1 1 0 1 0 1 0 1 1 1 0 1 0 1 0 0 1 0 0 0 0 1 0 1 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1 0 1 1 0 0];

%% ---------------------------------------QPSK System---------------------------------------------

%range of snr 
snrDB = 0:0.05:10; %signal to noise ratio in DB

bit_err = [];
symbol_err = [];

%sending the message bits into the system for different values of snr  
for i = 1:length(snrDB)
    
    snrDB_now = snrDB(i); %signal to noise ratio for this iteration
    
    disp(snrDB_now);
    
    %received bits for this iteration
    [modulated_symbols, demodulated_symbols,~, received_bits, msg_with_reps,~,~,~,~,~] = qpskSystem(message_bits,snrDB_now,reps,Label_format);    
    
    %bit error calculation for this iteration
    bit_err = [bit_err errorCheck(received_bits,msg_with_reps)]; 

    %symbol error calculation for this iteration
    symbol_err = [symbol_err errorCheck(modulated_symbols,demodulated_symbols)];
    
end

%% --------------------------------Theoretical Bit Error Rate-------------------------------------

%snr on linear scale
snr = 10.^(snrDB./10);

%using q function to get probability of error for a given SNR
if strcmp(Label_format,'Gray')
    theoretical_BER = qfunc(sqrt(2*snr));
elseif strcmp(Label_format,'Not Gray')
    theoretical_BER = 1.5*qfunc(sqrt(2*snr)) - qfunc(sqrt(2*snr)).*qfunc(sqrt(2*snr));
end

%% -----------------------------------------Demo-------------------------------------------------

%SNR for demo
snrDB_demo = 7;

%received symbols, bits and detection results for the given message
[modulated_symbols,~,noisy_symbols,~,~,recvd_msg,det_45,det_135,det_225,det_315] = qpskSystem(message_bits,snrDB_demo,20,Label_format);

%final demodulated message.
disp(num2str(recvd_msg));

%% ----------------------------------------Plotting-----------------------------------------------

figure(1);

%Empirical plot
semilogy(snrDB,bit_err);
grid on;
hold on;

%Theoretical plot
semilogy(snrDB,theoretical_BER);
hold on;

%symbol error rate
semilogy(snrDB,symbol_err);

title("Error Rates ("+Label_format+")");
ylabel("Error");
xlabel("SNR");
legend("Empirical BER","Theoretical BER","Symbol Error rate");


%plot for modulated and noisy symbols
figure(2);

plot(real(modulated_symbols),imag(modulated_symbols),'ro');
grid on;
hold on;
plot(real(noisy_symbols),imag(noisy_symbols),'bo');
title("Symbols");
ylabel("Imaginary");
xlabel("Real");
legend("Modulated","Noisy");

%plot for detection results
figure(3);

plot(real(det_45),imag(det_45),'ro'); %
grid on;
hold on;
plot(real(det_135),imag(det_135),'bo');
hold on;
plot(real(det_225),imag(det_225),'go');
hold on;
plot(real(det_315),imag(det_315),'yo');
title("Detection Results");
ylabel("Imaginary");
xlabel("Real");
legend("1+j","-1+j","-1-j","1-j");
