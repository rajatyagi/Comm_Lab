clc; 
close all;

%% --------------------------------------- parameter setup --------------------------------------------

Fs = 20000; %Sampling frequency in Hz

Ts = 1/Fs; %Sampling Period

fm = 200; %Message signal frequency in Hz

fc = 2000; %carrier frequency in Hz

nCycles = 20; %cycles of the message signal

Period_message = 1/fm; %Time period to complete one cycle in sec

t = 0:Ts:nCycles*Period_message; %Timeline

Am = 10; %amplitude of message

Ac = 10; %conventional AM passband carrier frequency component

mod_i = Am/Ac; %Modulation index of Conventional AM

%% ------------------------------------Message Signal (passband)---------------------------------------

message_t = Am*sin(2*pi*fm*t); %message signal in time domain - sinusoidal with frequency = fm Hz

normalized_message_t = message_t / Am; %Normalized Message Signal

%plotting the message signal
figure(1); 
subplot(2,1,1);
plot(t,message_t);
title("Message Signal in Time Domain");
xlabel("t (sec)");
ylabel("m(t)");
ylim([-1.5*Am 1.5*Am]);

%% -----------------------------------------Carrier Signal-------------------------------------------

carrier_t = cos(2*pi*fc*t); %carrier signal in time domain - sinusoidal with frequency = fc Hz

%plotting the carrier wave
subplot(2,1,2);
plot(t,carrier_t);
title("Carrier Signal in Time Domain");
xlabel("t (sec)");
ylabel("c(t)");
ylim([-1.5 1.5]);
xlim([0 20/fc]);

%% ------------------------------------------Modulation----------------------------------------------

conventional_AM_t = modulate(normalized_message_t,carrier_t,Ac,mod_i); %Modulated signal in time domain
conventional_AM_f = Ts*fftshift(fft(conventional_AM_t,8192)); %Modulated signal in frequency domain

Len_CAM_f = length(conventional_AM_f); %length of the DFT of conventional AM modulated signal in frequency domain

% Generating Frequency line
f = -Len_CAM_f/2 : 1 : Len_CAM_f/2 - 1; %iterating f from -len/2 to +len/2 

f = Fs*f/Len_CAM_f; %converting each term of f into frequency as for the 'k'th term f = Fs.k/N 

%plotting Modulated signal in Time and Frequency domain
figure(2);

% time domain plotting
subplot(2,1,1);
plot(t,conventional_AM_t);
title("Modulated Signal in Time Domain");
xlabel("t (sec)");
ylabel("Ucam(t)");

% frequency domain plotting
subplot(2,1,2);
plot(f,abs(conventional_AM_f));
title("Modulated Signal in Frequency Domain");
xlabel("f (Hz)");
ylabel("Ucam(f)");
xlim([-1.5*fc 1.5*fc]);

%% -----------------------------------------Demodulation----------------------------------------

recvd_message_t = demodulate(conventional_AM_t, carrier_t, fc, Fs, Ac); %Demodulated signal in time domain

%converting demodulated message into frequency domain
recvd_message_f = Ts*fftshift(fft(recvd_message_t,8192)); 

Len_CAM_f = length(recvd_message_f);  %length of the DFT of conventional AM modulated signal in frequency domain

f = -Len_CAM_f/2 : 1 : Len_CAM_f/2 - 1; %iterating f from -len/2 to +len/2 

f = Fs*f/Len_CAM_f; %converting each term of f into frequency as for the 'k'th term f = Fs.k/N 

%plotting demodulated signal in Time and Frequency domain
figure(3);

% time domain plotting
subplot(2,1,1);
plot(t,recvd_message_t);
title("Demodulated Signal in Time Domain");

% frequency domain plotting
subplot(2,1,2);
plot(f,abs(recvd_message_f));
xlim([-1000 1000]);
title("Demodulated Signal in frequency Domain");

%% ------------------------------------------Functions------------------------------------------

function conventional_AM_t = modulate(message_t , carrier_t , Ac , mod_i)

    conventional_AM_t = Ac*(1 + mod_i*message_t).*carrier_t; %Conventional AM Modulating technique

end 

function recvd_message_t = demodulate(conventional_AM_t, carrier_t, fc, Fs, Ac)

    %Step 1 - Multiplication with Carrier wave
    envelope = conventional_AM_t.*carrier_t;
    
    %Step 2 - Lowpass filtering
    [a,b] = butter(10,fc*1.2/Fs/2); %butterworth filter of order 10 and cutoff frequency 1.2*fc 
    envelope = filter(a,b,envelope);%filtering the envelope with the above created butterworth filter
    
    %Step 3 - Algebraically obtaining the message
    recvd_message_t = 2*envelope - Ac;
    
end 