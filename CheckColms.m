    function fixedColms = CheckColms(rawClues, sizeOfPuzzle)

        puzz = reshape(rawClues, sizeOfPuzzle, sizeOfPuzzle);

        %Moving through each colum
        for j = 1:sizeOfPuzzle
        %Checking the each row for duplicates
            [~, ind] = unique(puzz(:, j), 'rows');
            duplicate_ind = setdiff(1:size(puzz, 1), ind);
            duplicate_value = puzz(duplicate_ind, j);
            if(size(duplicate_value)< sizeOfPuzzle -2)
                for p = 1:sizeOfPuzzle
                    for b = 1:size(duplicate_value)
                        if(puzz(p, j) == duplicate_value(b))
                            puzz(p,j) = 0;
                        end
                    end
                end
            end
        end
        fixedColms = reshape(puzz, 1, sizeOfPuzzle^2);
    end