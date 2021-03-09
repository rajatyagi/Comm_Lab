function bit_err = errorCheck(received_bits,message_bits)

    error = 0;
    
    for i = 1:length(received_bits)
        
        %checking the number of wrong bits
        if received_bits(i) ~= message_bits(i)
            error = error + 1;
        end
        
    end
    
    %bit_err = no. wrong bits received / total no. of bits sent
    bit_err = error/length(received_bits);

end