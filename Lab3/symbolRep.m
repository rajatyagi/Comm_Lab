function signal_with_reps = symbolRep(x , reps)

    % creating a matrix with reps number of columns and each containing the message bits
    Symbol_matrix = repmat(x',1,reps);  
    
    %converting the matrix to a linear vector of repeated bits
    signal_with_reps = Symbol_matrix';
    signal_with_reps = signal_with_reps(:)';

end