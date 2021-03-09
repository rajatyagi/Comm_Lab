function recvd_bits = symbol2bits(recvd_symbols,format)

    recvd_bits = [];

    %format check
    if strcmp(format,'Gray')
        
        %bits assignment for every symbol
        for i = 1:length(recvd_symbols)

            symbol = recvd_symbols(i);
            
            % 0000 <-- -3+3j
            if symbol == -3 + 3i
                recvd_bits = [recvd_bits 0 0 0 0];
            % 0001 <-- -3+j
            elseif symbol == -3 + 1i
                recvd_bits = [recvd_bits 0 0 0 1];
            % 0010 <-- -3-3j
            elseif symbol == -3 - 3i
                recvd_bits = [recvd_bits 0 0 1 0];
            % 0011 <-- -3-j    
            elseif symbol == -3 - 1i
                recvd_bits = [recvd_bits 0 0 1 1];
            % 0100 <-- -1+3j    
            elseif symbol == -1 + 3i
                recvd_bits = [recvd_bits 0 1 0 0];
            % 0101 <-- -1+j    
            elseif symbol == -1 + 1i
                recvd_bits = [recvd_bits 0 1 0 1];
            % 0110 <-- -1-3j    
            elseif symbol == -1 - 3i
                recvd_bits = [recvd_bits 0 1 1 0];
            % 0111 <-- -1-1j    
            elseif symbol == -1 - 1i
                recvd_bits = [recvd_bits 0 1 1 1];
            % 1000 <-- 3+3j
            elseif symbol == 3 + 3i
                recvd_bits = [recvd_bits 1 0 0 0];
            % 1001 <-- 3+j
            elseif symbol == 3 + 1i
                recvd_bits = [recvd_bits 1 0 0 1];
            % 1010 <-- 3-3j
            elseif symbol == 3 - 3i
                recvd_bits = [recvd_bits 1 0 1 0];
            % 1011 <-- 3-j    
            elseif symbol == 3 - 1i
                recvd_bits = [recvd_bits 1 0 1 1];
            % 1100 <-- 1+3j    
            elseif symbol == 1 + 3i
                recvd_bits = [recvd_bits 1 1 0 0];
            % 1101 <-- 1+j    
            elseif symbol == 1 + 1i
                recvd_bits = [recvd_bits 1 1 0 1];
            % 1110 <-- 1-3j    
            elseif symbol == 1 - 3i
                recvd_bits = [recvd_bits 1 1 1 0];
            % 1111 <-- 1-j
            elseif symbol == 1 - 1i
                recvd_bits = [recvd_bits 1 1 1 1];
            end

        end
        
        %                           With Gray Labelling
        %                                    |
        %                   *          *    3|     *          *
        %                  0000       0100   |    1100       1000
        %                                    |
        %                                    |
        %                   *          *    1|     *          *
        %                  0001       0101   |    1101       1001   
        %         ___________________________|___________________________
        %                  -3         -1     |     1          3 
        %                                    |
        %                   *          *   -1|     *          *
        %                  0011       0111   |    1111       1011
        %                                    | 
        %                                    |
        %                   *          *   -3|     *          *
        %                  0010       0110   |    1110       1010
        %                                    |
    
    %format check
    elseif strcmp(format,'Not Gray')
        
        %bits assignment for every symbol
        for i = 1:length(recvd_symbols)

            symbol = recvd_symbols(i);
            
            % 0000 <-- -3+3j
            if symbol == -3 + 3i
                recvd_bits = [recvd_bits 0 0 0 0];
            % 0001 <-- -3+j
            elseif symbol == -3 + 1i
                recvd_bits = [recvd_bits 0 0 0 1];
            % 0010 <-- -3-j
            elseif symbol == -3 - 1i
                recvd_bits = [recvd_bits 0 0 1 0];
            % 0011 <-- -3-3j    
            elseif symbol == -3 - 3i
                recvd_bits = [recvd_bits 0 0 1 1];
            % 0100 <-- -1+3j    
            elseif symbol == -1 + 3i
                recvd_bits = [recvd_bits 0 1 0 0];
            % 0101 <-- -1+j    
            elseif symbol == -1 + 1i
                recvd_bits = [recvd_bits 0 1 0 1];
            % 0110 <-- -1-j    
            elseif symbol == -1 - 1i
                recvd_bits = [recvd_bits 0 1 1 0];
            % 0111 <-- -1-3j    
            elseif symbol == -1 - 3i
                recvd_bits = [recvd_bits 0 1 1 1];
            % 1000 <-- 1+3j
            elseif symbol == 1 + 3i
                recvd_bits = [recvd_bits 1 0 0 0];
            % 1001 <-- 1+j
            elseif symbol == 1 + 1i
                recvd_bits = [recvd_bits 1 0 0 1];
            % 1010 <-- 1-j
            elseif symbol == 1 - 1i
                recvd_bits = [recvd_bits 1 0 1 0];
            % 1011 <-- 1-3j    
            elseif symbol == 1 - 3i
                recvd_bits = [recvd_bits 1 0 1 1];
            % 1100 <-- 3+3j    
            elseif symbol == 3 + 3i
                recvd_bits = [recvd_bits 1 1 0 0];
            % 1101 <-- 3+j    
            elseif symbol == 3 + 1i
                recvd_bits = [recvd_bits 1 1 0 1];
            % 1110 <-- 3-j    
            elseif symbol == 3 - 1i
                recvd_bits = [recvd_bits 1 1 1 0];
            % 1111 <-- 3-3j
            elseif symbol == 3 - 3i
                recvd_bits = [recvd_bits 1 1 1 1];
            end

        end
        
        %                          Without Gray Labelling
        %                                    |
        %                   *          *    3|     *          *
        %                  0000       0100   |    1000       1100
        %                                    |
        %                                    |
        %                   *          *    1|     *          *
        %                  0001       0101   |    1001       1101   
        %         ___________________________|___________________________
        %                  -3         -1     |     1          3 
        %                                    |
        %                   *          *   -1|     *          *
        %                  0010       0110   |    1010       1110
        %                                    | 
        %                                    |
        %                   *          *   -3|     *          *
        %                  0011       0111   |    1011       1111
        %                                    |                  
        
    end

end