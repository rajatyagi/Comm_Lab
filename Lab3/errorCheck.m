function err = errorCheck(received_entries,message_entries)

    error = 0;
    
    for i = 1:length(received_entries)
        
        %checking the number of wrong entries
        if received_entries(i) ~= message_entries(i)
            error = error + 1;
        end
        
    end
    
    %bit_err = no. wrong entries received / total no. of entries sent 
    err = error/length(received_entries);

end