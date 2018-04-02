% Script that forms the row logic matrix for an NxN sudoku puzzle

function res = Acol(N)

    Inxn = eye(N);
    Ocoln = zeros(N, (N^2 - N));

    col1 = [];
    for i = 1:1:N
        col1 = [col1, Inxn, Ocoln];
    end

    colsMid = [];
    for row = 2:1:N-1
        colTemp = [];
        colTemp = [colTemp, zeros(N,N*(row-1))];
        for i = 1:1:N
            if (i ~= 4)
                colTemp = [colTemp, Inxn, Ocoln];
            else
                colTemp = [colTemp, Inxn];
            end
        end
        colTemp = [colTemp, zeros(N,(N^2 - N)-N*(row-1))];
        colsMid = [colsMid; colTemp];
    end

    colN = [];
    for i = 1:1:N
        colN = [colN, Ocoln, Inxn];
    end

    res = [col1; colsMid; colN];
    
end