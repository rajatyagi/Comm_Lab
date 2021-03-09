function [qpsk_symbols, received_symbols, noisy_symbols, received_bits, msg_with_reps, final_msg,det_45,det_135,det_225,det_315] = qpskSystem(message_bits, snrdb, reps , label_format)
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
    
    %(ii) repeating bits
    msg_with_reps = bitRep(message_bits,reps);
         
    %step 2 converting the bits to symbols
    
    qpsk_symbols = [];   %empty symbol array
    
    for i = 1: 2 :length(msg_with_reps)

        %checking 2 bits at a time
        buffer = [msg_with_reps(i) msg_with_reps(i+1)];
        
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
    sigma = sqrt(1/(2*snr_now)); %noise scaling parameter for each dimension
    awgn = sigma*(  randn(1,length(qpsk_symbols))  +  1i*randn(1,length(qpsk_symbols))  ); %AWGN noise 

    %Noise Addition
    noisy_symbols = qpsk_symbols + awgn; %Adding noise to the modulated symbols.

    %% ---------------------------------------Demodulation-------------------------------------------

    %Step1: symbol detection by Quadrant check(using phase)
    received_symbols = []; %array to store received symbols
    
    %arrays to store detection results
    det_45 = [];
    det_135 = [];
    det_225 = [];
    det_315 = [];

    for i = 1:length(noisy_symbols)
        
        %Detection of the symbol using ML rule (Checking the quadrant it lies in)
        detected_symbol = symbol_detector(noisy_symbols(i));
        
        %storing the detection result of the given symbol (will be used later for plotting in demo)
        if detected_symbol == 1+1i
            det_45 = [det_45 noisy_symbols(i)];
        elseif detected_symbol == -1+1i
            det_135 = [det_135 noisy_symbols(i)];
        elseif detected_symbol == -1-1i
            det_225 = [det_225 noisy_symbols(i)];
        elseif detected_symbol == 1-1i
            det_315 = [det_315 noisy_symbols(i)];
        end
        
        %Received Symbol 
        received_symbols = [received_symbols detected_symbol];

    end
        
    %Step2 converting Symbols to bits according to the given labelling format
    %this step is required for BER calculation 
    received_bits = symbol2bits(received_symbols,label_format);
        
    %Step3 removing reps from the received symbols.
    final_symbols = repRemove(received_symbols,reps);
    
    %Step4 getting the message from final symbols 
    recvd_msg = symbol2bits(final_symbols,label_format);
    
    %removing the initialization bits and converting to original format.
    
    if recvd_msg(1) == 0 && recvd_msg(2) == 0 %check if the original bit stream had even length
        final_msg = recvd_msg(3:length(recvd_msg)); 
        
    else %check if the original bit stream had odd length
        final_msg = recvd_msg(3:length(recvd_msg)-1);
        
    end
    
end