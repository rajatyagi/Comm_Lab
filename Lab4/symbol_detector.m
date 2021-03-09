function detected_symbol = symbol_detector(symbol) 

    %Phase of the current symbol in degrees
    phase = angle(symbol)*180/pi;

    %Symbol Detection using ML Rule:

    %if phase --> [0,90] symbol = 1+j     I Quadrant
    if phase >= 0 && phase < 90
        detected_symbol = 1+1i;

    %if phase --> [90,180] symbol = -1+j  II Quadrant
    elseif phase >= 90 && phase < 180
        detected_symbol = -1+1i;

    %if phase --> [0,-90] symbol = 1-j    IV Quadrant
    elseif phase < 0 && phase >= -90
        detected_symbol = 1-1i;

    %if phase --> [-90,-180] symbol = -1-j  III Quadrant  
    elseif phase < -90 && phase >= -180
        detected_symbol = -1-1i;
    end

end