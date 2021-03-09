close all;
clear all;
clc;

%% ----------------------------------------Parameter Setup----------------------------------------

iterations = 10000; %repititions for each symbol
Ts = 1/iterations; %sampling time in seconds
Fs = 1/Ts; %sampling frequency in Hz
T = 1; %Bit duration in seconds
Label_format = 'Gray'; %Labelling Format

%% ------------------------------------------Message----------------------------------------------

message_bits = randi([0,1],1,iterations); %gererating random message bits 
%disp(message_bits);
%% ---------------------------------------DBPSK System---------------------------------------------

%range of snr 
snrDB = 0:0.05:10; %signal to noise ratio in DB

err_dbpsk = [];
err_bpsk = [];
err_dqpsk = [];

%sending the message bits into the system for different values of snr  
for i = 1:length(snrDB)
    
    snrDB_now = snrDB(i); %signal to noise ratio for this iteration
    
    disp(snrDB_now);
    
    %received bits for this dbpsk in this iteration
    recvd_dbpsk = dbpskSystem(message_bits,snrDB_now);
    
    %bit error calculation for DBPSK
    err_dbpsk = [err_dbpsk errorCheck(recvd_dbpsk,message_bits)];
    
    %received bits for this bpsk in this iteration
    recvd_bpsk = bpskSystem(message_bits,snrDB_now);
    
    %bit error calculation for BPSK
    err_bpsk = [err_bpsk errorCheck(recvd_bpsk,message_bits)];
    
    %received bits for this dqpsk in this iteration
    recvd_dqpsk = dqpskSystem(message_bits,snrDB_now,Label_format);    
    
    %bit error calculation for DQPSK
    err_dqpsk = [err_dqpsk errorCheck(recvd_dqpsk,message_bits)]; 
    
end

%% --------------------------------Theoretical Bit Error Rate-------------------------------------

%snr on linear scale
snr = 10.^(snrDB./10);

%using q function to get probability of error for a given SNR for DBPSK
theoretical_BER = 2*qfunc(sqrt(2*snr)) - 2*qfunc(sqrt(2*snr)).^2;

%% ----------------------------------------Plotting-----------------------------------------------

figure(1);

%Empirical plot
semilogy(snrDB,err_dbpsk);
hold on;
semilogy(snrDB,err_dqpsk);
hold on;
semilogy(snrDB,err_bpsk);
hold on;
%Theoretical plot
semilogy(snrDB,theoretical_BER);
grid on;
title("BER Plot (Not Gray)");
xlabel('SNR in DB (Eb/No)');
legend('DBPSK' , 'DQPSK' , 'BPSK','Theoretical BER for DBPSK');

figure(1);

% %Empirical plot
% figure(1)
% semilogy(snrDB,err_dqpsk);
% title("BER Plot (Not Gray)");
% xlabel('SNR in DB (Eb/No)');
% legend('DQPSK');
