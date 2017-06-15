function M = dps_example_one()
% 3 by 3 example from [DPS03], eq. 69
    M = zeros(9, 9);
    psiplus = zeros(1, 9);
    psiplus(1) = 1/sqrt(3); %00 component
    psiplus(5) = 1/sqrt(3); %11 component
    psiplus(9) = 1/sqrt(3); %22 component
    M(1, 1) = 2; %2|00><00|
    M(5, 5) = 2; %2|11><11|
    M(9, 9) = 2; %2|22><22|
    M(3, 3) = 1; %|02><02|
    M(4, 4) = 1; %|10><10|
    M(8, 8) = 1; %|21><21|
    M = M - 3*psiplus'*psiplus;
    M = eye(9) - M;
    
    
