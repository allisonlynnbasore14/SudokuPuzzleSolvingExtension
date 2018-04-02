    function fixedBoxes = CheckBoxes(rawClues, sizeOfPuzzle)

        puzz = reshape(rawClues, sizeOfPuzzle, sizeOfPuzzle)';
        puzz = shapeBox(puzz);
        %Moving through each colum
        for j = 1:sizeOfPuzzle
        %Checking the each row for duplicates
            [~, ind] = unique(puzz(:, j), 'rows');
            duplicate_ind = setdiff(1:size(puzz, 1), ind);
            duplicate_value = puzz(duplicate_ind, j);
            if(size(duplicate_value)==1)
                for p = 1:sizeOfPuzzle
                    for b = 1:size(duplicate_value)
                        if(puzz(p, j) == duplicate_value(b))
                            puzz(p,j) = 0;
                        end
                    end
                end
            end
        end
        boxes = unshapeBox(puzz);
        fixedBoxes = reshape(boxes', 1, sizeOfPuzzle^2);
    end
    
    
    function done = shapeBox(puzz)
        temp = puzz;

        puzz(1:3,1) = temp(1,1:3);
        puzz(4:6,1) = temp(2,1:3);
        puzz(7:9,1) = temp(3,1:3);
        
        puzz(1:3,2) = temp(1,4:6);
        puzz(4:6,2) = temp(2,4:6);
        puzz(7:9,2) = temp(3,4:6);
        
        puzz(1:3,3) = temp(1,7:9);
        puzz(4:6,3) = temp(2,7:9);
        puzz(7:9,3) = temp(3,7:9);
        
        %now for the second row of boxes
        puzz(1:3,4) = temp(4,1:3);
        puzz(4:6,4) = temp(5,1:3);
        puzz(7:9,4) = temp(6,1:3);
        
        puzz(1:3,5) = temp(4,4:6);
        puzz(4:6,5) = temp(5,4:6);
        puzz(7:9,5) = temp(6,4:6);
        
        puzz(1:3,6) = temp(4,7:9);
        puzz(4:6,6) = temp(5,7:9);
        puzz(7:9,6) = temp(6,7:9);
        
        % Now for the last row of boxes
        
        puzz(1:3,7) = temp(7,1:3);
        puzz(4:6,7) = temp(8,1:3);
        puzz(7:9,7) = temp(9,1:3);
        
        puzz(1:3,8) = temp(7,4:6);
        puzz(4:6,8) = temp(8,4:6);
        puzz(7:9,8) = temp(9,4:6);
        
        puzz(1:3,9) = temp(7,7:9);
        puzz(4:6,9) = temp(8,7:9);
        puzz(7:9,9) = temp(9,7:9);
        
        done = puzz;
    end
    
    function done = unshapeBox(puzz)
    
        temp = puzz;
        
        puzz(1,1:3) = temp(1:3,1);
        puzz(2,1:3) = temp(4:6,1);
        puzz(3,1:3) = temp(7:9,1);
        
        puzz(1,4:6) = temp(1:3,2);
        puzz(2,4:6) = temp(4:6,2);
        puzz(3,4:6) = temp(7:9,2);
        
        puzz(1,7:9) = temp(1:3,3);
        puzz(2,7:9) = temp(4:6,3);
        puzz(3,7:9) = temp(7:9,3);
        
        %now for the second row of boxes
        puzz(4,1:3) = temp(1:3,4);
        puzz(5,1:3) = temp(4:6,4);
        puzz(6,1:3) = temp(7:9,4);
        
        puzz(4,4:6) = temp(1:3,5);
        puzz(5,4:6) = temp(4:6,5);
        puzz(6,4:6) = temp(7:9,5);
        
        puzz(4,7:9) = temp(1:3,6);
        puzz(5,7:9) = temp(4:6,6);
        puzz(6,7:9) = temp(7:9,6);
        
        % Now for the last row of boxes
        
        puzz(7,1:3) = temp(1:3,7);
        puzz(8,1:3) = temp(4:6,7);
        puzz(9,1:3) = temp(7:9,7);
        
        puzz(7,4:6) = temp(1:3,8);
        puzz(8,4:6) = temp(4:6,8);
        puzz(9,4:6) = temp(7:9,8);
        
        puzz(7,7:9) = temp(1:3,9);
        puzz(8,7:9) = temp(4:6,9);
        puzz(9,7:9) = temp(7:9,9);
        
        done = puzz;
    end
    
    
  