function symbol = bits2symbol(bits,format)

    %With Gray Labelling
    if strcmp(format,'Gray')

        % 00 --> 1+j
        if bits(1) == 0 && bits(2) == 0
            symbol = 1 + 1i;
        % 01 --> -1+j
        elseif bits(1) == 0 && bits(2) == 1
            symbol = -1 + 1i;
        % 10 --> -1-j    
        elseif bits(1) == 1 && bits(2) == 0
            symbol = 1 - 1i;
        % 11 --> 1-j    
        elseif bits(1) == 1 && bits(2) == 1
            symbol = -1 - 1i; 
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

    %Without Gray Labelling
    elseif strcmp(format,'Not Gray')

        % 00 --> 1+j
        if bits(1) == 0 && bits(2) == 0
            symbol = 1 + 1i;
        % 01 --> -1+j
        elseif bits(1) == 0 && bits(2) == 1
            symbol = -1 + 1i;
        % 10 --> -1-j    
        elseif bits(1) == 1 && bits(2) == 0
            symbol = -1 - 1i;
        % 11 --> 1-j    
        elseif bits(1) == 1 && bits(2) == 1
            symbol = 1 - 1i; 
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