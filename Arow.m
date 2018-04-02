% Script that forms the row logic matrix for an NxN sudoku puzzle

function res = Arow(N)

    Inxn = eye(N);

    row1 = [];
    for i = 1:1:N
        row1 = [row1, Inxn];
    end
    row1 = [row1, zeros(N, N^2*(N-1))];

    rowsMid = [];
    for row = 2:1:N-1
        rowTemp = [zeros(N,(row-1)*N^2)];
        for j = 1:1:N
            rowTemp = [rowTemp, Inxn];
        end
        rowTemp = [rowTemp, zeros(N,(N^3-(row*(N^2))))];
        rowsMid = [rowsMid; rowTemp];
    end

    rowN = [];
    for i = 1:1:N
        rowN = [rowN, Inxn];
    end
    rowN = [zeros(N, N^2*(N-1)), rowN];

    res = [row1; rowsMid; rowN];
    
end