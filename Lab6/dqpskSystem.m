function final_msg = dqpskSystem(message_bits, snrdb , label_format)
    %% -----------------------------------------Modulation--------------------------------------------

    %step 1 Preprocessing
    
    %(i) adding an initialization code 
    if rem(length(message_bits),2) == 0    %if the message has even number of bits

        %Adding two zeros at the begining of the bit stream
        message_bits = [0 0 message_bits];
    
    elseif rem(length(message_bits),2) ~= 0    %if the message has odd number of bits

        %Adding two ones at the begining of the bit stream and one zero at the end to make it even
        message_bits = [1 1 message_bits 0];
    
    end
             
    %step 2 converting the bits to symbols
    
    qpsk_symbols = [];   %empty symbol array
    
    for i = 1: 2 :length(message_bits)

        %checking 2 bits at a time
        buffer = [message_bits(i) message_bits(i+1)];
        
        %symbol for the specified format        
        symbol = bits2symbol(buffer , label_format);

        %appending the symbol to the symbol array
        qpsk_symbols = [qpsk_symbols  symbol];
        
    end
        
    %differential encoding of qpsk symbols
    dqpsk_symbols = dqpsk_encoding(qpsk_symbols);
            
    %% ------------------------------------------Channel---------------------------------------------

    %Signal to noise ratio 
    snrdb_now = snrdb; %signal to noise ratio in DB for this iteration
    snr_now = 10^(snrdb_now/10); %signal to noise ratio on linear scale for this iteration

    %Noise Generation
    sigma = sqrt(1/(2*snr_now)); %noise scaling parameter for each dimension
    awgn = sigma*(  randn(1,length(dqpsk_symbols))  +  1i*randn(1,length(dqpsk_symbols))  ); %AWGN noise 

    %Noise Addition
    noisy_symbols = (dqpsk_symbols) + awgn; %Adding noise to the modulated symbols.

    %% ---------------------------------------Demodulation-------------------------------------------

    %Step1: symbol detection by Quadrant check(using phase)
    recvd_dqpsk = []; %array to store received symbols

    for i = 1:length(noisy_symbols)
        
        %Detection of the symbol using ML rule (Checking the quadrant it lies in)
        detected_symbol = symbol_detector(noisy_symbols(i));
        
        %Received Symbol 
        recvd_dqpsk = [recvd_dqpsk detected_symbol];

    end 
    
    %Step1 Decoding the given differential sequence
    recvd_qpsk = dqpsk_decoding(recvd_dqpsk);
        
    %Step2 getting the message from final symbols 
    recvd_msg = symbol2bits(recvd_qpsk,label_format);
    
    %removing the initialization bits and converting to original format.
    
    if recvd_msg(1) == 0 && recvd_msg(2) == 0 %check if the original bit stream had even length
        final_msg = recvd_msg(3:length(recvd_msg)); 
        
    else %check if the original bit stream had odd length
        final_msg = recvd_msg(3:length(recvd_msg)-1);
        
    end
    
end