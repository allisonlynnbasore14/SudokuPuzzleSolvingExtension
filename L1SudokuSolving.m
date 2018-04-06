

% This script produces a solved Sudoku puzzle with inputs of the clues of a
% Sudoku puzzle. By using linear programming optimization, we are able to
% find the solutions based on the L1 norm of a constraint matrix. The
% constraint matrix is devised by the clues and size of the Sudoku puzzle.


%Here are what the inputs are:
% orginClues  is an array with all values of the puzzle
% guesses is the same as orginClues, this is here for interations through
% the algoritum
% iterCount is a number between 0 and 10. If you want only one iteration, then use 10, if you want 10 iterations, use 1
% solution is the solution to the puzzle, this is used to break out of the
% function if it gets the right answer

%Here is an example inputs:
%input3 = [4 3 0 2 6 0 7 8 1 6 8 0 0 7 0 0 9 3 0 9 7 8 0 4 0 0 2 8 2 0 1 0 5 0 4 0 0 7 4 6 0 2 0 0 5 9 0 1 7 0 3 6 2 8 0 1 0 3 2 6 8 7 0 2 4 8 9 0 7 0 3 0 7 6 3 4 0 8 2 0 0];
%solution = [4 3 5 2 6 9 7 8 1 6 8 2 5 7 1 4 9 3 1 9 7 8 3 4 5 6 2 8 2 6 1 9 5 3 4 7 3 7 4 6 8 2 9 1 5 9 5 1 7 4 3 6 2 8 5 1 9 3 2 6 8 7 4 2 4 8 9 5 7 1 3 6 7 6 3 4 1 8 2 5 9];

%Here is a map of how the indicies of the input clues vector correspond to
%the acutal puzzle
% -  -  -  -  -  -  -  -  - -
%|1 | 2| 3| 4| 5| 6| 7| 8| 9|
%|10|11|12|13|14|15|16|17|18|
%|19|20|21|22|23|24|25|26|27|
%|28|29|30|31|32|33|34|35|36|
%|37|38|39|40|41|42|43|44|45|
%|46|47|48|49|50|51|52|53|54|
%|55|56|57|58|59|60|61|62|63|
%|64|65|66|67|68|69|70|71|72|
%|73|74|75|76|77|78|79|80|81|
% -  -  -  -  -  -  -  -  - -

function sol = L1SudokuSolving(orginClues, guesses, iterCount, solution, tempCol, tempBox)
    sizeOfPuzzle = sqrt(length(orginClues));
    %size of one side of the puzzle i.e. 9
    rawGuesses =  guesses;
    %Saves values
    guesses = arrangeClues(guesses);
    %Guesses refers to a previous iterations's attempt at solving
    
    %Call makeA to find the A contraint matrix
    A =  produceA(sizeOfPuzzle, rawGuesses, tempCol, tempBox);
    %sol = A;
    %return
    %Make b matrix to solve for x: Ax = b
    b = ones(size(A,1),1);
    %Setting up and running minimization
    m = size(A,1);
    n = size(A,2);
    %x = linprog(zeros(1,size(A,2)),A,b)';
    cvx_begin
        variable x(n)
        cvx_quiet(true)
        cvx_precision best
        minimize( norm( x , 1 ))
        % norm( x , 1 )
        subject to
            A*x == b;
    cvx_end
    
    
    
    %Max number of time it will iterate through the algoritum
    iterationThresh = 10;
    if(iterCount >= iterationThresh)
        %If we are done iterating, exit with the current best solution
        wraped = wrapper(x, sizeOfPuzzle);
        Iterations = -1*(4 - iterCount);
        sol = wraped;
    else
        wraped = wrapper(x, sizeOfPuzzle);
        
        %wrapper takes the outputs of the CXV tool and makes it into the
        %puzzle
        NUMBERWRONG = checker(wraped, solution);
        if(NUMBERWRONG == 0)
            % If we have zero wrong, break out of the function and return
            % our solution
            Iterations = -1*(4 - iterCount)
            sol = wraped;
            return
        end
        holder = rawGuesses;
        x = reshape(x,[9,81]);
        thres = 0.3;
        for t = 1:size(x,2)
            [maxi,ind] = max(abs(x(:,t)));
            if (maxi >= thres && holder(t) < 0.99)
                % If the maximum value in the x CVX out is above the
                % threshold and not already a clue, then it added it to our
                % solution
                holder(t) = ind;
                %holder hold out current solution
            end
        end
        fixedRows = CheckRows(holder, sizeOfPuzzle);
        fixedColms = CheckColms(holder, sizeOfPuzzle);
        fixedBoxes = CheckBoxes(holder, sizeOfPuzzle);
        % The above three function check for the rules of the puzzle.
        % If there is a violation, the numbers are removed.
        
        for u = 1:size( fixedBoxes, 2)
            if( fixedBoxes(u) == 0 | fixedColms(u)==0 | fixedRows(u)==0 )
                holder(u) = 0;
                %Does a cross check across all three functions
            end
            if(orginClues(u) ~= 0)
                %puts the original clues back
                 holder(u) = orginClues(u);
            end
        end
        
        NUMBERWRONG = checker(holder, solution);
        if(NUMBERWRONG < 4)
            % If we have less than four cells wrong, the puzzle is sent to
            % the brute force function to get the last few solved
            if(NUMBERWRONG == 0)
                Iterations = -1*(4 - iterCount)
                sol = wraped;
                return
            end
            Iterations = -1*(4 - iterCount)
            out = bruteSolve(holder);
            sol = out;
            return       
        else
            iterCount = iterCount + 1;
        end
        %CheckedBackeds is called which runs the CVX algoritum of the
        %puzzle with it fliped upside down
        %This effective solves a diffrent puzzle with the same solution
        checkedBackwards = checkBackwards(sizeOfPuzzle, holder, orginClues, solution, tempCol, tempBox);
        NUMBERWRONG = checker(checkedBackwards, solution);
        if(NUMBERWRONG < 4)
            % This is checked after the backwards, left-right, and right-left
            % functions
            if(NUMBERWRONG == 0)
                Iterations = -1*(4 - iterCount)
                sol = checkedBackwards;
                return
            end
            Iterations = -1*(4 - iterCount)
            out = bruteSolve(checkedBackwards);
            sol = out;
            return
        end
        
        checkedRL = checkRightLeft(sizeOfPuzzle, checkedBackwards, orginClues, solution, tempCol, tempBox);
        %checkRightLeft is called which runs the CVX algoritum of the
        %puzzle with it fliped to the right
        %This effective solves a diffrent puzzle with the same solution
        NUMBERWRONG = checker(checkedRL, solution);
        
        if(NUMBERWRONG < 4)
            if(NUMBERWRONG == 0)
                Iterations = -1*(4 - iterCount)
                sol = checkedRL;
                return
            end
            Iterations = -1*(4 - iterCount)
            out = bruteSolve(checkedRL);
            sol = out;
            return
        end        
        
        checkedLR = checkLeftRight(sizeOfPuzzle, checkedRL, orginClues, solution, tempCol, tempBox);
        %checkLeftRight is called which runs the CVX algoritum of the
        %puzzle with it fliped to the right
        %This effective solves a diffrent puzzle with the same solution
        NUMBERWRONG = checker(checkedLR, solution);
        
        if(NUMBERWRONG < 4)
            if(NUMBERWRONG == 0)
                Iterations = -1*(4 - iterCount)
                sol = checkedLR;
                return
            end
            Iterations = -1*(4 - iterCount)
            out = bruteSolve(checkedLR);
            sol = out;
            return
        end  
        % The function's iteration is called
        Iterations = -1*(4 - iterCount)
        sol = L1SudokuSolving(orginClues, checkedLR, iterCount, solution, tempCol, tempBox);
    end
end


function done = checkBackwards(sizeOfPuzzle, clues ,oriClues, solution, tempCol, tempBox)
    %This function is very simular to L1SudokuSolving

    %This function is for running a puzzle filpped upside down
    %Since the puzzle is basically a system that you are solving, the
    %beginning values are harder to solve than the last values. By flipping
    %the puzzle, we can sovle the beginning cells as if they were at the
    %end
    
    clues = fliplr(clues);
    %Filps the puzzle
    
    rawClues = clues;
    clues = arrangeClues(clues);
    A =  produceA(sizeOfPuzzle, rawClues, tempCol, tempBox);
    b = ones(size(A,1),1);
    m = size(A,1);
    n = size(A,2);
    cvx_begin
        cvx_quiet(true)
        variable x(n)
        minimize( norm( x , 1 ) )
        subject to
            A*x == b;
    cvx_end
    holder = rawClues;
    x = reshape(x,[9,81]);
    wraped = wrapper(x, 9);
    
    NUMBERWRONG = checker(wraped, fliplr(solution));
    
    if(NUMBERWRONG == 0)
        out = wraped;
        return
    end
    
    for t = 1:size(x,2)
        [~,ind] = max(abs(x(:,t)));
        if (holder(t) < 0.99)
            
            holder(t) = ind;
        end
    end
    fixedRows = CheckRows(holder, sizeOfPuzzle);
    fixedColms = CheckColms(holder, sizeOfPuzzle);
    fixedBoxes = CheckBoxes(holder, sizeOfPuzzle);
    %filping the clues
    oriClues = fliplr(oriClues);
    for u = 1:size( fixedBoxes, 2)
        if( fixedBoxes(u) == 0 | fixedColms(u)==0 | fixedRows(u)==0 )
            holder(u) = 0;
        end
        if(oriClues(u) ~= 0)
            holder(u) = oriClues(u);
        end
    end
    %converting the solution back to front side up
    done = fliplr(holder);
end



function done = checkLeftRight(sizeOfPuzzle, clues ,oriClues, solution, tempCol, tempBox)
    %This function is very simular to checkRightLeft and checkBackwards

    %This function is for running a puzzle filpped to the left
    %Since the puzzle is basically a system that you are solving, the
    %beginning values are harder to solve than the last values. By flipping
    %the puzzle, we can sovle the beginning cells as if they were at the
    %end
    
    clues = reshape(clues,sizeOfPuzzle, sizeOfPuzzle)';
    clues = rot90(clues);
    clues = reshape(clues',1,sizeOfPuzzle^2);
    
    solution = reshape(solution,sizeOfPuzzle, sizeOfPuzzle)';
    solution = rot90(solution);
    solution = reshape(solution',1,sizeOfPuzzle^2);
    
    oriClues = reshape(oriClues,sizeOfPuzzle, sizeOfPuzzle)';
    oriClues = rot90(oriClues);
    oriClues = reshape(oriClues',1,sizeOfPuzzle^2);
    
    rawClues = clues;
    clues = arrangeClues(clues);
    A =  produceA(sizeOfPuzzle, rawClues, tempCol, tempBox);
    b = ones(size(A,1),1);
    m = size(A,1);
    n = size(A,2);
    cvx_begin
        cvx_quiet(true)
        variable x(n)
        minimize( norm( x , 1 ) )
        subject to
            A*x == b;
    cvx_end
    holder = rawClues;
    x = reshape(x,[9,81]);
    wraped = wrapper(x, 9);
    
    for t = 1:size(x,2)
        [~,ind] = max(abs(x(:,t)));
        if (holder(t) < 0.99)
            holder(t) = ind;
        end
    end
    
    fixedRows = CheckRows(holder, sizeOfPuzzle);
    fixedColms = CheckColms(holder, sizeOfPuzzle);
    fixedBoxes = CheckBoxes(holder, sizeOfPuzzle);
    
    for u = 1:size( fixedBoxes, 2)
        if( fixedBoxes(u) == 0 | fixedColms(u)==0 | fixedRows(u)==0 )
            holder(u) = 0;
        end
        if(oriClues(u) ~= 0)
             holder(u) = oriClues(u);
        end
    end
    
    %Converts it back to right side up
    guesses = reshape(holder, sizeOfPuzzle, sizeOfPuzzle)';
    guesses = rot90(rot90(rot90(guesses)));
    guesses = reshape(guesses', 1,sizeOfPuzzle^2);
    
    done = guesses;

end


function done = checkRightLeft(sizeOfPuzzle, clues ,oriClues, solution, tempCol, tempBox)
    %This function is very simular to checkLeftRight and checkBackwards

    %This function is for running a puzzle filpped to the right
    %Since the puzzle is basically a system that you are solving, the
    %beginning values are harder to solve than the last values. By flipping
    %the puzzle, we can sovle the beginning cells as if they were at the
    %end
    
    clues = reshape(clues,sizeOfPuzzle, sizeOfPuzzle)';
    clues = rot90(rot90(rot90(clues)));
    clues = reshape(clues',1,sizeOfPuzzle^2);
    
    solution = reshape(solution,sizeOfPuzzle, sizeOfPuzzle)';
    solution = rot90(rot90(rot90(solution)));
    solution = reshape(solution',1,sizeOfPuzzle^2);
    
    oriClues = reshape(oriClues,sizeOfPuzzle, sizeOfPuzzle)';
    oriClues = rot90(rot90(rot90(oriClues)));
    oriClues = reshape(oriClues',1,sizeOfPuzzle^2);
    
    rawClues = clues;
    RC = reshape(rawClues, 9,9);
    clues = arrangeClues(clues);
    A = produceA(sizeOfPuzzle,rawClues, tempCol, tempBox);
    %Translate the solution
    f = zeros(1, size(A,2));
    b = ones(size(A,1),1);
    %sol = linprog(f,A,b);
    m = size(A,1);
    n = size(A,2);
    cvx_begin
        cvx_quiet(true)
        variable x(n)
        minimize( norm( x , 1 ) )
        subject to
            A*x == b;
    cvx_end
    holder = rawClues;
    x = reshape(x,[9,81]);
    wraped = wrapper(x, 9);
    
    NUMBERWRONG = checker(wraped, solution);
    for t = 1:size(x,2)
        [~,ind] = max(abs(x(:,t)));
        if (holder(t) < 0.99)
            holder(t) = ind;
        end
    end
    
    reshape(holder,9,9)';
    fixedRows = CheckRows(holder, sizeOfPuzzle);
    FR = reshape(fixedRows, 9,9);
    fixedColms = CheckColms(holder, sizeOfPuzzle);
    FC = reshape(fixedColms, 9,9);
    fixedBoxes = CheckBoxes(holder, sizeOfPuzzle);
    reshape(fixedBoxes,9,9)';
           
    for u = 1:size( fixedBoxes, 2)
        if( fixedBoxes(u) == 0 | fixedColms(u)==0 | fixedRows(u)==0 )
            holder(u) = 0;
        end
        if(oriClues(u) ~= 0)
             holder(u) = oriClues(u);
        end
    end

    %Putting it back right side up
    guesses = reshape(holder, sizeOfPuzzle, sizeOfPuzzle)';
    guesses = rot90(guesses);
    guesses = reshape(guesses', 1,sizeOfPuzzle^2);
    
    done = guesses;

end

function output = wrapper(x, N)
    holder = zeros(1,N^2);
    x = reshape(x,[N,81]);
    for i = 1:length(holder)
        [~, idx] = max(abs(x(:,i)));
        holder(i) = idx;
    end
    output = holder;
end

function clueA = getAClue(N, clues)
    holdM = [];
    for i=1:2:size(clues,2)
        holdV = zeros(1,N^3);
        val = clues(i);
        pos = clues(i+1);
        holdV(N*pos - N + val) = 1;
        holdM = [holdM;holdV];
    end
    clueA = holdM;
end

function cellA = getACell(N, ~)
    cells = [];

    for i=1:N^2
        startpos = (i-1)*N + 1;
        cell = zeros(1,N^3);
        cell(1, startpos:startpos + N -1) = ones(1, N);
        cells = [cells ; cell]; 
    end
    
    cellA = cells;
end

function done = bruteSolve(puzz)
    bank = find(puzz==0);
    holder = puzz;
    if(size(bank,2)==3)
        for i = 1:9
            holder(bank(1)) = i;
            for j = 1:9
                holder(bank(2)) = j;
                for k = 1:9
                    holder(bank(3)) = k;
                    RowsW0 = size(find(CheckRows(holder, 9) ==0),2);
                    if(RowsW0==0)
                        BoxsW0 = size(find(CheckBoxes(holder, 9)==0),2);
                        if(BoxsW0==0)
                            ColmW0 = size(find(CheckColms(holder, 9)==0),2);
                            if(ColmW0==0)
                                done = holder;
                                return
                            end
                        end
                    end
                end
            end
        end
        done = 0;
    end
    if(size(bank,2)==2)
        for i = 1:9
            holder(bank(1)) = i;
            for j = 1:9
                holder(bank(2)) = j;
                RowsW0 = size(find(CheckRows(holder, 9) ==0),2);
                if(RowsW0==0)
                    BoxsW0 = size(find(CheckBoxes(holder, 9)==0),2);
                    if(BoxsW0==0)
                        ColmW0 = size(find(CheckColms(holder, 9)==0),2);
                        if(ColmW0==0)
                            done = holder;
                            return
                        end
                    end
                end
            end
        end
        done = 0;
    end
    if(size(bank,2)==1)
        for i = 1:9
            holder(bank(1)) = i;
            ColmW0 = size(find(CheckColms(holder, 9)==0),2);
            if(ColmW0==0)
                done = holder;
                return
            end
        end
        done = holder;
    end
   done = holder;
end


function A = produceA(sizeOfPuzzle, clues, tempCol, tempBox)
    clues = arrangeClues(clues);
    AClue = getAClue(sizeOfPuzzle, clues);
   
    ACell = getACell(sizeOfPuzzle );
    
    ABox = Abox(sizeOfPuzzle);
    ARow = Arow(sizeOfPuzzle);
    ACol = Acol(sizeOfPuzzle);
    A = [ACell ; ARow ;  tempCol;    tempBox; AClue] ;

end



function clues = arrangeClues( Rawclues )
    cluesHolder = [];
    for i = 1:size(Rawclues, 2)
        if(Rawclues(i) > 0)
            cluesHolder = [cluesHolder Rawclues(i) i];
        end
    end
    clues = cluesHolder;
end



