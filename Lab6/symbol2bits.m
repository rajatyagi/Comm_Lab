function recvd_bits = symbol2bits(recvd_symbols,format)

    recvd_bits = [];

    %format check
    if strcmp(format,'Gray')
        
        %bits assignment for every symbol
        for i = 1:length(recvd_symbols)

            symbol = recvd_symbols(i);
            
            % 1+j --> 00
            if symbol == 1 + 1i
                recvd_bits = [recvd_bits 0 0];
            % -1+j --> 01
            elseif symbol == -1 + 1i
                recvd_bits = [recvd_bits 0 1];
            % -1-j --> 11    
            elseif symbol == -1 - 1i
                recvd_bits = [recvd_bits 1 1];
            % 1-j --> 10    
            elseif symbol == 1 - 1i
                recvd_bits = [recvd_bits 1 0];
            end

        end
        
        %          With Gray Labelling
        %                  |
        %          01 *    |    * 00
        %                  |
        %         _________|_________
        %                  |
        %                  |
        %          11 *    |    * 10
        %                  |
    
    %format check
    elseif strcmp(format,'Not Gray')
        
        %bits assignment for every symbol
        for i = 1:length(recvd_symbols)

            symbol = recvd_symbols(i);
            
            % 1+j --> 00
            if symbol == 1 + 1i
                recvd_bits = [recvd_bits 0 0];
            % -1+j --> 01
            elseif symbol == -1 + 1i
                recvd_bits = [recvd_bits 0 1];
            % 1-j --> 11    
            elseif symbol == 1 - 1i
                recvd_bits = [recvd_bits 1 1];
            % -1-j --> 10    
            elseif symbol == -1 - 1i
                recvd_bits = [recvd_bits 1 0];
            end

        end
        
        %        Without Gray Labelling
        %                  |
        %          01 *    |    * 00
        %                  |
        %         _________|_________
        %                  |
        %                  |
        %          10 *    |    * 11
        %                  |
        
    end

end