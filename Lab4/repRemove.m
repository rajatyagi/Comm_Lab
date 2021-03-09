function final_symbols = repRemove(symbols,reps)

    final_symbols = [];
    
    for i = 1:reps:length(symbols)-1
        sym = 0;
        for j = 0:reps-1
            sym = sym + symbols(i+j); %taking the sum of 'reps' number of bits 
        end
        
        %detecting wich was the mostlikely repeated symbol by using symbol detector on mean of a set of 'reps' number of symbols
        final_symbols = [final_symbols symbol_detector(sym/reps)];
    end
        
end