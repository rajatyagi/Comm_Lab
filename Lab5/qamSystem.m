function [qpsk_symbols, received_symbols, noisy_symbols, received_bits, msg_with_reps, final_msg,result] = qamSystem(message_bits, snrdb, reps , label_format)
    %% -----------------------------------------Modulation--------------------------------------------

    %step 1 Preprocessing
        
    extra_bits = 4 - rem(length(message_bits),4); %number of bits to be added to message to make its length divisible by 4
    
    %(i) adding an initialization code 
    if extra_bits == 4    %if the message has even number of bits

        %Adding four zeros at the begining of the bit stream
        message_bits = [0 0 0 0 message_bits];
    
    elseif extra_bits == 1    %if the message has odd number of bits

        %Adding 0001 at the begining of the bit stream and one zero at the end to make it even
        message_bits = [0 0 0 1 message_bits 0];
    
    elseif extra_bits == 2    %if the message has odd number of bits

        %Adding 0001 at the begining of the bit stream and one zero at the end to make it even
        message_bits = [0 0 1 1 message_bits 0 0];
        
    elseif extra_bits == 3    %if the message has odd number of bits

        %Adding 0001 at the begining of the bit stream and one zero at the end to make it even
        message_bits = [0 1 1 1 message_bits 0 0 0];
        
    end
        
    %(ii) repeating bits
    msg_with_reps = bitRep(message_bits,reps);
         
    %step 2 converting the bits to symbols
    
    qpsk_symbols = [];   %empty symbol array
    
    for i = 1: 4 :length(msg_with_reps)

        %checking 4 bits at a time
        buffer = [msg_with_reps(i) msg_with_reps(i+1) msg_with_reps(i+2) msg_with_reps(i+3)];
        
        %symbol for the specified format        
        symbol = bits2symbol(buffer , label_format);

        %appending the symbol to the symbol array
        qpsk_symbols = [qpsk_symbols  symbol];
        
    end
        
    %% ------------------------------------------Channel---------------------------------------------

    %Signal to noise ratio 
    snrdb_now = snrdb; %signal to noise ratio in DB for this iteration
    snr_now = 10^(snrdb_now/10); %signal to noise ratio on linear scale for this iteration

    %Noise Generation
    sigma = sqrt(5/(4*snr_now)); %noise scaling parameter for each dimension
    awgn = sigma*(  randn(1,length(qpsk_symbols))  +  1i*randn(1,length(qpsk_symbols))  ); %AWGN noise 

    %Noise Addition
    noisy_symbols = qpsk_symbols + awgn; %Adding noise to the modulated symbols.

    %% ---------------------------------------Demodulation-------------------------------------------

    %Step1: symbol detection by Quadrant check(using phase)
    received_symbols = []; %array to store received symbols
    result = []; %array to store noisy symbols with their corresponding detection results

    for i = 1:length(noisy_symbols)
        
        %Detection of the symbol using ML rule (Checking the quadrant it lies in)
        detected_symbol = symbol_detector(noisy_symbols(i));

        %Received Symbol 
        received_symbols = [received_symbols detected_symbol];

        %storing the results of detection
        result = [result ; [noisy_symbols(i) detected_symbol]];
        
    end
        
    %Step2 converting Symbols to bits according to the given labelling format
    %this step is required for BER calculation 
    received_bits = symbol2bits(received_symbols,label_format);
        
    %Step3 removing reps from the received symbols.
    final_symbols = repRemove(received_symbols,reps);
    
    %Step4 getting the message from final symbols 
    recvd_msg = symbol2bits(final_symbols,label_format);
    
    %removing the initialization bits and converting to original format.
    
    %converting first 4 bits of the received bits into str for simplicity
    bit_str = num2str([recvd_msg(1) recvd_msg(2) recvd_msg(3) recvd_msg(4)]);
    %removing the blank spaces
    bit_str(isspace(bit_str)) = '';
    
    
    %removal of extra bits
    if strcmp(bit_str,'0000') %check if the original bit stream had no extra bits
        final_msg = recvd_msg(5:length(recvd_msg)); 
        
    elseif strcmp(bit_str,'0001') %check if the original bit stream had 1 extra bit
        final_msg = recvd_msg(5:length(recvd_msg)-1);
    
    elseif strcmp(bit_str,'0011') %check if the original bit stream had 2 extra bit
        final_msg = recvd_msg(5:length(recvd_msg)-2);
        
    elseif strcmp(bit_str,'0111') %check if the original bit stream had 3 extra bit
        final_msg = recvd_msg(5:length(recvd_msg)-3);
        
    end
    
end