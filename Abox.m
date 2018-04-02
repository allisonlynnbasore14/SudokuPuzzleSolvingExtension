function res = Abox(N)

    Inxn = eye(N);

    Jn = [];
    for i = 1:1:sqrt(N)
       Jn = [Jn, Inxn];
    end

    box1 = [];
    base = size(Jn,2);
    Oboxn = zeros(N, base);
    for i = 1:1:sqrt(N)
        if (i ~= sqrt(N))
            box1 = [box1, Jn, Oboxn];
        else
            box1 = [box1, Jn];
        end
    end
    rest = size(box1, 2);
    box1 = [box1, zeros(N,N^3-rest)];

    row = 4;

    boxRest = [];
    for row = 2:1:N
        boxTemp = [];
        boxTemp = [boxTemp, zeros(N,(row-1)*base)];
        for i = 1:1:sqrt(N)
            if (i ~= sqrt(N))
                boxTemp = [boxTemp, Jn, Oboxn];
            else
                boxTemp = [boxTemp, Jn];
            end
        end
        rest = size(boxTemp, 2);
        boxTemp = [boxTemp, zeros(N,N^3-rest)];
        boxRest = [boxRest; boxTemp];
    end

    %res = [box1; boxRest];
    N = 9;
    I = eye(N);
    j = [I I I];
    box1 = [zeros(N, 0* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (3*3*N) - 2 *( N^2 - size(j,2)))];
    box2 = [zeros(N, 1* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (4*3*N) - 2 *( N^2 - size(j,2)))];
    box3 = [zeros(N, 2* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (5*3*N) - 2 *( N^2 - size(j,2)))];
    box4 = [zeros(N, 3* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (6*3*N) - 2 *( N^2 - size(j,2)))];
    box5 = [zeros(N, 4* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (7*3*N) - 2 *( N^2 - size(j,2)))];
    box6 = [zeros(N, 5* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (8*3*N) - 2 *( N^2 - size(j,2)))];
    box7 = [zeros(N, 6* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (9*3*N) - 2 *( N^2 - size(j,2)))];
    box8 = [zeros(N, 7* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (10*3*N) - 2 *( N^2 - size(j,2)))];
    box9 = [zeros(N, 8* (3*N)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^2 - size(j,2)) j zeros(N, N^3 - (11*3*N) -2 *( N^2 - size(j,2)))];

    boxes = [box1;box2;box3;box4;box5;box6;box7;box8;box9];
    res = boxes;
end