function recvd_qpsk = dqpsk_decoding(recvd_dqpsk)

    %array to store decoded qpsk symbols
    recvd_qpsk = [];
    
    for i = 2:length(recvd_dqpsk)
        
        %calculating the phase of the qpsk symbol by take phase difference of dqpsk symbols
        symbol_phase = (180/pi)*angle(recvd_dqpsk(i)) + ((180/pi)*angle(recvd_dqpsk(i-1)) - 45);
        
        %assigning symbol accorfing to phase of the decoded symbol
        if symbol_phase == 45 || symbol_phase == -315
            recvd_qpsk = [recvd_qpsk 1+1i];
        elseif symbol_phase == -45 || symbol_phase == 315
            recvd_qpsk = [recvd_qpsk 1-1i];
        elseif symbol_phase == 135 || symbol_phase == -225
            recvd_qpsk = [recvd_qpsk -1+1i];
        elseif symbol_phase == 225 || symbol_phase == -135
            recvd_qpsk = [recvd_qpsk -1-1i];
        end
    end
    
end