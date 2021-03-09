
snr = 10.^(snrDB./10);

theoretical_BER = qfunc(sqrt(2*snr));

figure(2);
semilogy(snrDB,bit_err,'-o');
hold on;
semilogy(snrDB,theoretical_BER);
grid on;
title("Bit Error Rate");
ylabel("Error");
xlabel("SNR");
legend("Empirical","Theoretical");
xlim([0 10.1]);
% message_bits = [1 0 1 1 0 1 1 0 1 0 1 0 1 1 1 0 1 0 1 0 0 1 0 0 0 0 1 0 1 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1 0 1 1 0];
% 
% bb = repmat(message_bits',1,100);
% disp(bb);
% signal_with_reps = bb';
% disp(signal_with_reps);
% signal_with_reps = signal_with_reps(:)';
% disp(signal_with_reps);