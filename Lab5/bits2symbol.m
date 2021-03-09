function symbol = bits2symbol(bits,format)

    %converting the bit array into string for simplicity and better readability
    bit_str = num2str(bits);
    %removing the blank spaces
    bit_str(isspace(bit_str)) = '';

    %With Gray Labelling
    if strcmp(format,'Gray')

        % 0000 --> -3+3j
        if strcmp(bit_str,"0000")
            symbol = -3 + 3i;
        % 0001 --> -3+j
        elseif strcmp(bit_str,'0001')
            symbol = -3 + 1i;
        % 0010 --> -3-3j
        elseif strcmp(bit_str,'0010')
            symbol = -3 - 3i;
        % 0011 --> -3-j    
        elseif strcmp(bit_str,'0011')
            symbol = -3 - 1i; 
        % 0100 --> -1+3j    
        elseif strcmp(bit_str,'0100')
            symbol = -1 + 3i;
        % 0101 --> -1+j    
        elseif strcmp(bit_str,'0101')
            symbol = -1 + 1i;
        % 0110 --> -1-3j    
        elseif strcmp(bit_str,'0110')
            symbol = -1 - 3i;
        % 0111 --> -1-1j    
        elseif strcmp(bit_str,'0111')
            symbol = -1 - 1i;
        % 1000 --> 3+3j    
        elseif strcmp(bit_str,'1000')
            symbol = 3 + 3i;
        % 1001 --> 3+j
        elseif strcmp(bit_str,'1001')
            symbol = 3 + 1i;
        % 1010 --> 3-3j
        elseif strcmp(bit_str,'1010')
            symbol = 3 - 3i;
        % 1011 --> 3-j    
        elseif strcmp(bit_str,'1011')
            symbol = 3 - 1i;
        % 1100 --> 1+3j    
        elseif strcmp(bit_str,'1100')
            symbol = 1 + 3i;
        % 1101 --> 1+j    
        elseif strcmp(bit_str,'1101')
            symbol = 1 + 1i;
        % 1110 --> 1-3j    
        elseif strcmp(bit_str,'1110')
            symbol = 1 - 3i;
        % 1111 --> 1-j
        elseif strcmp(bit_str,'1111')
            symbol = 1 - 1i;
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

    %Without Gray Labelling
    elseif strcmp(format,'Not Gray')

        % 0000 --> -3+3j
        if strcmp(bit_str,'0000')
            symbol = -3 + 3i;
        % 0001 --> -3+j
        elseif strcmp(bit_str,'0001')
            symbol = -3 + 1i;
        % 0010 --> -3-j
        elseif strcmp(bit_str,'0010')
            symbol = -3 - 1i;
        % 0011 --> -3-3j    
        elseif strcmp(bit_str,'0011')
            symbol = -3 - 3i; 
        % 0100 --> -1+3j    
        elseif strcmp(bit_str,'0100')
            symbol = -1 + 3i;
        % 0101 --> -1+j    
        elseif strcmp(bit_str,'0101')
            symbol = -1 + 1i;
        % 0110 --> -1-1j    
        elseif strcmp(bit_str,'0110')
            symbol = -1 - 1i;
        % 0111 --> -1-3j    
        elseif strcmp(bit_str,'0111')
            symbol = -1 - 3i;
        % 1000 --> 1+3j    
        elseif strcmp(bit_str,'1000')
            symbol = 1 + 3i;
        % 1001 --> 1+j
        elseif strcmp(bit_str,'1001')
            symbol = 1 + 1i;
        % 1010 --> 1-1j
        elseif strcmp(bit_str,'1010')
            symbol = 1 - 1i;
        % 1011 --> 1-3j    
        elseif strcmp(bit_str,'1011')
            symbol = 1 - 3i;
        % 1100 --> 3+3j    
        elseif strcmp(bit_str,'1100')
            symbol = 3 + 3i;
        % 1101 --> 3+j    
        elseif strcmp(bit_str,'1101')
            symbol = 3 + 1i;
        % 1110 --> 3-1j    
        elseif strcmp(bit_str,'1110')
            symbol = 3 - 1i;
        % 1111 --> 1-j
        elseif strcmp(bit_str,'1111')
            symbol = 3 - 3i;
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