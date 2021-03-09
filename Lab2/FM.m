close all;
clc;

%% --------------------------------------- parameter setup --------------------------------------------

Fs = 1000000; %Sampling frequency in Hz

Ts = 1/Fs; %Sampling Period

fm = 200; %Message signal frequency in Hz

fc = 5000; %carrier frequency in Hz

nCycles = 20; %cycles of the message signal

Period_message = 1/fm; %Time period to complete one cycle in sec

Am = 5; %amplitude of message

Ac = 10; %amplitude of the carrier

kf = 750; %sensitivity of the frequency modulator

t = 0:Ts:nCycles*Period_message; %Time line

N = 2^(2+ceil(log2((length(t))))); %Length of DFT -> nearest power of 2 greater than the length of message array 

f = -Fs/2 : Fs/N : Fs/2 - Fs/N; %frequency line as for the 'k'th DFT term has f = Fs.k/N

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

carrier_t = Ac*cos(2*pi*fc*t); %carrier signal in time domain - sinusoidal with frequency = fc Hz

%plotting the carrier wave
subplot(2,1,2);
plot(t,carrier_t);
title("Carrier Signal in Time Domain");
xlabel("t (sec)");
ylabel("c(t)");
ylim([-1.5*Ac 1.5*Ac]);
xlim([0 20/fc]);

%% ------------------------------------------ Modulation -------------------------------------------

FM_t = modulate(message_t, fc, Ac, t); %Modulated signal in time domain
FM_f = fftshift(fft(FM_t,N))/length(FM_t); %Modulated signal in frequency domain

%plotting Modulated signal in Time and Frequency domain
figure(2);

% time domain plotting
subplot(2,1,1);
plot(t,FM_t);
title("Modulated Signal in Time Domain");
xlabel("t (sec)");
ylabel("Umod(t)");
ylim([-1.5*Ac 1.5*Ac]);
xlim([0 0.01]);

% frequency domain plotting
subplot(2,1,2);
plot(f,abs(FM_f));
title("Modulated Signal in Frequency Domain");
xlabel("f (Hz)");
ylabel("Umod(f)");
xlim([-10500 10500]);

%% ------------------------------------------ Demodulation -------------------------------------------

[recvd_message_t,FM_diff] = demodulate(FM_t, fc, Ts, Ac, kf); %Demodulated signal in time domain
recvd_message_f = fftshift(fft(recvd_message_t,N))/length(recvd_message_t); %Demodulated signal in frequency domain

%plotting Modulated signal in Time and Frequency domain
figure(3);
plot(t,FM_diff);
title("Differentiation of FM modulated Signal in Time Domain");
xlabel("t (sec)");
ylabel("U(t)");
xlim([0 0.015]);

%plotting Demodulated signal in Time and Frequency domain
figure(4);

% time domain plotting
subplot(2,1,1);
plot(t,recvd_message_t);
title("Demodulated Signal in Time Domain");
xlabel("t (sec)");
ylabel("Udem(t)");
xlim([0 0.04]);

% frequency domain plotting
subplot(2,1,2);
plot(f,abs(recvd_message_f));
title("Demodulated Signal in Frequency Domain");
xlabel("f (Hz)");
ylabel("Udem(f)");
xlim([-1000 1000]);

%% ------------------------------------------Functions------------------------------------------

function FM_t = modulate(message_t,fc, Ac, t)

    kf = 750; %The design parameter.

    theta_t = 2*pi*kf*cumtrapz(t,message_t); %Phase of the carrier containing the integral of message 

    FM_t = Ac*cos(2*fc*pi*t + theta_t); %FM Modulating technique adding the phase to the carrier

end 

function [recvd_message_t,FM_diff] = demodulate(FM_t,fc, Ts, Ac, kf)

    %Step 1 - Differentiation of FM modulated signal 
    FM_diff = diff(FM_t)/Ts; %slope of consecutive elements -> Amplitude difference / Time difference(Ts)
    FM_diff = ([FM_diff 0]); % adding extra element at the end as diff reduces the array size by 1
    
    %Step 2 - Envelope detection
    FM_envelope = abs(hilbert(FM_diff));

    %Step 3 - Algebraically obtaining the message
    recvd_message_t = (FM_envelope/(2*pi) - fc*Ac)/(kf*Ac);
    
end