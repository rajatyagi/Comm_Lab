close all;
clc;

%% ----------------------------------------Parameter Setup----------------------------------------

reps = 1000; %repititions for each symbol
Ts = 1/reps; %sampling time in seconds
Fs = 1/Ts; %sampling frequency in Hz
T = 1; %Bit duration in seconds
Label_format = 'Gray'; %Labelling Format

%% ------------------------------------------Message----------------------------------------------

message_bits = [0 0 0 0 0 0 0 1 0 0 1 0 0 0 1 1 0 1 0 0 0 1 0 1 0 1 1 0 0 1 1 1 1 0 0 0 1 0 0 1 1 0 1 0 1 0 1 1 1 1 0 0 1 1 0 1 1 1 1 0 1 1 1 1];

%% ---------------------------------------16-QAM System---------------------------------------------

%range of snr 
snrDB = 0:0.1:10; %signal to noise ratio in DB

bit_err = [];
symbol_err = [];

%sending the message bits into the system for different values of snr  
for i = 1:length(snrDB)
    
    snrDB_now = snrDB(i); %signal to noise ratio for this iteration
    
    disp(snrDB_now);
    
    %received bits for this iteration
    [modulated_symbols, demodulated_symbols,~, received_bits, msg_with_reps] = qamSystem(message_bits,snrDB_now,reps,Label_format);    
    
    %bit error calculation for this iteration
    bit_err = [bit_err errorCheck(received_bits,msg_with_reps)]; 

    %symbol error calculation for this iteration
    symbol_err = [symbol_err errorCheck(modulated_symbols,demodulated_symbols)];
    
end

%% --------------------------------Theoretical Bit Error Rate-------------------------------------

%snr on linear scale
snr = 10.^(snrDB./10);

%Value of theoretical SER calculated--- proof given in report.
theoretical_SER = ((3)*qfunc(2*sqrt(snr/5)) - (9/4)*qfunc(2*sqrt(snr/5)).^2);

%using q function to get probability of error for a given SNR
if strcmp(Label_format,'Gray')
    %Proof not available taken from online source
    theoretical_BER = (3/4)*qfunc(2*sqrt(snr/5));
elseif strcmp(Label_format,'Not Gray')
    %Proof not available estimated by trial and error
    theoretical_BER = ((21/20)*qfunc(2*sqrt(snr/5)) - (63/80)*qfunc(2*sqrt(snr/5)).^2);
end

%% -----------------------------------------Demo-------------------------------------------------

%SNR for demo
snrDB_demo = 0;

%received symbols, bits and detection results for the given message
[modulated_symbols,~,noisy_symbols,~,~,recvd_msg,result] = qamSystem(message_bits,snrDB_demo,1000,Label_format);

%final demodulated message bits.
disp('Demodulated message signal is:');
disp(num2str(recvd_msg));

%% ----------------------------------------Plotting-----------------------------------------------

% figure(1);
% 
% %Empirical plot
% semilogy(snrDB,bit_err,'-bo');
% grid on;
% hold on;
% 
% %Theoretical plot
% semilogy(snrDB,theoretical_BER,'r');
% hold on;
% 
% %symbol error rate
% semilogy(snrDB,symbol_err,'-mo');
% hold on;
% 
% %Theoretical plot
% semilogy(snrDB,theoretical_SER,'k');
% 
% title("Error Rates ("+Label_format+")");
% ylabel("Error");
% xlabel("SNR");
% legend("Empirical BER",'approximate Theoretical BER',"Symbol Error rate","Theoretical SER");


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
%plotting different detected symbols in different colors
gscatter(real(result(:,1)),imag(result(:,1)),result(:,2),'rgbcymk','hspd'); 
grid on;
title("Detection Results");
ylabel("Imaginary");
xlabel("Real");
