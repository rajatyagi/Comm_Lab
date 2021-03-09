function final_symbols = repRemove(symbols,reps)

    final_symbols = [];
    
    for i = 1:reps:length(symbols)-1
        %finding the most frequent symbol by finding the mode of the repeated symbols. 
        final_symbols = [final_symbols mode(symbols(i:i+reps-1))];
    end
        
end