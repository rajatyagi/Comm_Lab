
function received_bits = dbpskSystem(message_bits, snrdb)
    %% -----------------------------------------Modulation--------------------------------------------

    
    %step 1 differential encoding of bits
    dbpsk_bit(1) = 1; %design parameter
    
    for i = 1:length(message_bits)
       
        dbpsk_bit(i+1) = not(xor(dbpsk_bit(i),message_bits(i))); %xnor of the consequtive bits for encoding
        
    end
        
    %step 2 converting DBPSK bits to BPSK Symbols
    bpskSymbols = 2*dbpsk_bit - 1; 
   
    %% ------------------------------------------Channel---------------------------------------------

    %Signal to noise ratio 
    snrdb_now = snrdb; %signal to noise ratio in DB for this iteration
    snr_now = 10^(snrdb_now/10); %signal to noise ratio on linear scale for this iteration

    %Noise Generation
    sigma = sqrt(1/(2*snr_now)); %noise scaling parameter for each dimension
    awgn = sigma*randn(1,length(bpskSymbols)); %AWGN noise 

    %Noise Addition
    noisy_symbols = bpskSymbols + awgn; %Adding noise to the modulated symbols.
    
    %% ---------------------------------------Demodulation-------------------------------------------

    %Symbol detection by amplitude check
    recvd_symbols = []; %array to store received symbols

    for i = 1:length(noisy_symbols)

        %Symbol Detection using ML Rule ==> if amplitude > 0 symbol = 1 and -1 otherwise
        if noisy_symbols(i)>= 0
            detected_symbol = 1;
        else
            detected_symbol = -1;
        end

        %Received Symbol 
        recvd_symbols = [recvd_symbols detected_symbol];

    end
            
    %received dbpsk bits
    dbpsk_recvd = 0.5*(recvd_symbols + 1);
    
    %decoding the DBPSK bits
    for i = 2:length(dbpsk_recvd)
    
        received_bits(i-1) = not(xor(dbpsk_recvd(i),dbpsk_recvd(i-1)));
        
    end
    
end