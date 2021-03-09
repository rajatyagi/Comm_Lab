clc; 
close all;

%% --------------------------------------- parameter setup --------------------------------------------

Fs = 20000; %Sampling frequency in Hz

Ts = 1/Fs; %Sampling Period

fm = 200; %Message signal frequency in Hz

fc = 2000; %carrier frequency in Hz

nCycles = 20; %cycles of the message signal

Period_message = 1/fm; %Time period to complete one cycle in sec

t = Ts:Ts:nCycles*Period_message; %Timeline

Am = 5; %amplitude of message

Ac = 10; %amplitude of the carrier

%% ------------------------------------Message Signal (passband)---------------------------------------

message_t = Am*sin(2*pi*fm*t); %message signal in time domain - sinusoidal with frequency = fm Hz

%plotting the message signal
figure(1); 
subplot(2,1,1);
plot(t,message_t);
title("Message Signal in Time Domain");
xlabel("t (sec)");
ylabel("m(t)");
ylim([-1.5*Am 1.5*Am]);

%% -----------------------------------------Carrier Signal-------------------------------------------

carrier_t_I = (Ac/sqrt(2))*cos(2*pi*fc*t); %I component of carrier signal in time domain - sinusoidal with frequency = fc Hz
carrier_t_Q = Ac*sin(2*pi*fc*t)/sqrt(2); %Q component of in time domain - sinusoidal with frequency = fc Hz

carrier_t = carrier_t_I + carrier_t_Q;

%plotting the carrier wave
subplot(2,1,2);
plot(t,carrier_t);
title("Carrier Signal in Time Domain");
xlabel("t (sec)");
ylabel("c(t)");
ylim([-1.5*Ac 1.5*Ac]);
xlim([0 20/fc]);

%% ------------------------------------------Modulation----------------------------------------------

SSB_SC_t = modulate(message_t,carrier_t_I,carrier_t_Q); %Modulated signal in time domain
SSV_SC_f = Ts*fftshift(fft(SSB_SC_t,8192)); %Modulated signal in frequency domain 

Len_SSB_f = length(SSV_SC_f); %length of the DFT of conventional AM modulated signal in frequency domain

% Generating Frequency line
f = -Len_SSB_f/2 : 1 : Len_SSB_f/2 - 1; %iterating f from -len/2 to +len/2

f = Fs*f/Len_SSB_f; %converting each term of f into frequency as for the 'k'th term f = Fs.k/N 

%plotting Modulated signal in Time and Frequency domain
figure(2);

% time domain plotting
subplot(2,1,1);
plot(t,SSB_SC_t);
title("Modulated Signal in Time Domain");
xlabel("t (sec)");
ylabel("Ucam(t)");
ylim([-1.5*Ac*Am 1.5*Ac*Am]);
xlim([0 10/fm]);

% frequency domain plotting
subplot(2,1,2);
plot(f,abs(SSV_SC_f));
title("Modulated Signal in Frequency Domain");
xlabel("f (Hz)");
ylabel("Ucam(f)");
xlim([-1.5*fc 1.5*fc]);

%% -----------------------------------------Demodulation----------------------------------------

recvd_message_t = demodulate(SSB_SC_t, carrier_t_I, fc, Fs);

%converting demodulated message into frequency domain
recvd_message_f = fftshift(fft(recvd_message_t,8192))/Fs; 

Len_SSB_f = length(recvd_message_f);  %length of the DFT of conventional AM modulated signal in frequency domain

f = -Len_SSB_f/2 : 1 : Len_SSB_f/2 - 1; %iterating f from -len/2 to +len/2 

f = Fs*f/Len_SSB_f; %converting each term of f into frequency as for the 'k'th term f = Fs.k/N 

%plotting demodulated signal in Time and Frequency domain
figure(3);

% time domain plotting
subplot(2,1,1);
plot(t,recvd_message_t);
title("Demodulated Signal in Time Domain");
ylim([-1.5*Am 1.5*Am]);

% frequency domain plotting
subplot(2,1,2);
plot(f,abs(recvd_message_f));
xlim([-1000 1000]);
title("Demodulated Signal in frequency Domain");

%% ------------------------------------------Functions------------------------------------------

function SSB_SC_t = modulate(message_t , carrier_t_I , carrier_t_Q)

    %taking hilbert transform of message signal 
    hilbert_message = imag(hilbert(message_t)); %considering only imaginary part as we want pi/2 shifted version of m(t)
    
    SSB_SC_t = message_t.*carrier_t_I + hilbert_message.*carrier_t_Q; %SSB-SC AM Modulating technique for LSB

end 

function recvd_message_t = demodulate(SSB_SC_t, carrier_t_I, fc, Fs)

    %Step 1 - Multiplication with I-Component of Carrier wave
    envelope = SSB_SC_t.*(carrier_t_I);
    
    %Step 2 - Lowpass filtering
    [a,b] = butter(10,fc*1.2/Fs/2); %lowpass butterworth filter with order 10 and cutoff fc*1.2
    envelope = filter(a,b,envelope);%filtering the envelope with the above created butterworth filter
    
    %Step 3 - Algebraically obtaining the message
    recvd_message_t = 2*envelope/(min(carrier_t_I)*min(carrier_t_I)); %dividing the message signal with the square of carrier Amplitude
    
end