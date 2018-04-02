

function out = checker(correct, answers)
    count = 0;
    for i = 1:length(answers)
        if(correct(i) ~= answers(i))
            count = count + 1;
        end
    
    end
    out = count;
end