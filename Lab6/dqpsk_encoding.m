function dqpsk_symbol = dqpsk_encoding(symbol) 

    %Phase of the current symbol in degrees
    qpsk_phase = angle(symbol)*180/pi;

    dqpsk_symbol = [];
    dqpsk_symbol(1) = 1+1i; %initializing the first symbol (Design parameter)
    
    for i = 1:length(symbol)

        %computation of phase difference between current qpsk symbol and previous dqpsk symbol
        phase_diff = qpsk_phase(i) - angle(dqpsk_symbol(i))*180/pi;
        
        %if phase difference --> [0] symbol = 1+j     
        if phase_diff == 0
            dqpsk_symbol(i+1) = 1+1i;

        %if phase difference --> [90 or -270] symbol = -1+j  
        elseif phase_diff == 90 || phase_diff == -270
            dqpsk_symbol(i+1) = -1+1i;

        %if phase difference --> [-90 or 270] symbol = 1-j    
        elseif phase_diff == -90 || phase_diff == 270
            dqpsk_symbol(i+1) = 1-1i;

        %if phase difference --> [180 or -180] symbol = -1-j 
        elseif phase_diff == -180 || phase_diff == 180
            dqpsk_symbol(i+1) = -1-1i;
        end
    
    end

end