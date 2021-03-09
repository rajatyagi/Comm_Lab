function detected_symbol = symbol_detector(symbol) 

    %Phase of the current symbol in degrees
    phase = angle(symbol)*180/pi;

    %1)checking the quadrant of the received symbol:
    %2)assigning center = center of the 4 symbols in that quadrant
    %3)again checking the phase of (symbol-center) to know which of the four symbols in the quadrant 
    
    %if phase --> [0,90] I Quadrant
    if phase >= 0 && phase < 90
        center = 2+2i;

    %if phase --> [90,180] II Quadrant
    elseif phase >= 90 && phase < 180
        center = -2+2i;

    %if phase --> [0,-90] IV Quadrant
    elseif phase < 0 && phase >= -90
        center = 2-2i;

    %if phase --> [-90,-180] III Quadrant  
    elseif phase < -90 && phase >= -180
        center = -2-2i;
    end
    
    %subtracting the center from the symbol to check which of the four symbols in the quadrant does it belong
    symbol = symbol - center;
    %phase of the new symbol
    phase = angle(symbol)*180/pi;
    
    %if phase --> [0,90] symbol = center + (1+j)
    if phase >= 0 && phase < 90
        detected_symbol = center + (1+1i);

    %if phase --> [90,180] symbol = center + (-1+j)
    elseif phase >= 90 && phase < 180
        detected_symbol = center + (-1+1i);

    %if phase --> [0,-90] symbol = center + (1-j)
    elseif phase < 0 && phase >= -90
        detected_symbol = center + (1-1i);

    %if phase --> [-90,-180] symbol = center + (-1-j)  
    elseif phase < -90 && phase >= -180
        detected_symbol = center + (-1-1i);
    end
        
end