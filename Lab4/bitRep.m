function msg_with_reps = bitRep(x , reps)

    x_1 = [];
    
    %creating matrix Ex:  00110110  --> | 00 |
    %                                   | 11 |
    %                                   | 01 |
    %                                   | 10 |
                                            
    
    for i = 1:2:length(x)
        x_1 = [x_1;[x(i) x(i+1)]];
    end
    
    % creating a matrix with reps number of columns and each containing the message bits
    Symbol_matrix = repmat(x_1,1,reps);  

    %converting the matrix to a linear vector of repeated bits
    msg_with_reps = Symbol_matrix';
    msg_with_reps = msg_with_reps(:)';
    
end