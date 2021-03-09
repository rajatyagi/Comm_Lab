
function [received_bits , message_with_reps] = bpskSystem(message_bits, snrdb, reps)
    %% -----------------------------------------Modulation--------------------------------------------

    %step 1 repeating the bits 'reps' number of times
    message_with_reps = symbolRep(message_bits , reps); 
    
    %step 2 convert bits to BPSK Symbols
    bpsk_symbols = 2*message_with_reps - 1; 

    %% ------------------------------------------Channel---------------------------------------------

    %Signal to noise ratio 
    snrdb_now = snrdb; %signal to noise ratio in DB for this iteration
    snr_now = 10^(snrdb_now/10); %signal to noise ratio on linear scale for this iteration

    %Noise Generation
    sigma = sqrt(1/(2*snr_now)); %noise scaling parameter for each dimension
    awgn = sigma*randn(1,length(bpsk_symbols)); %AWGN noise 

    %Noise Addition
    noisy_symbols = bpsk_symbols + awgn; %Adding noise to the modulated symbols.

    %% ---------------------------------------Demodulation-------------------------------------------

    %Symbol detection by amplitude check
    received_symbols = []; %array to store received symbols

    for i = 1:length(bpsk_symbols)

        %Symbol Detection using ML Rule ==> if amplitude > 0 symbol = 1 and -1 otherwise
        if noisy_symbols(i)>= 0
            detected_symbol = 1;
        else
            detected_symbol = -1;
        end

        %Received Symbol 
        received_symbols = [received_symbols detected_symbol];

    end
    
    %converting Symbols to bits
    received_bits = 0.5*(received_symbols + 1);
    
end