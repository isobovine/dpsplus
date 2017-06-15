function Msym = sep_to_prodsym(dim, M)

% input is a real symmetric M, output is real symmetric M',
% such that hSep(M) = hProdsym(M')
Msym = zeros((2*dim)^2, (2*dim)^2);
% We want to set Msym(0a1b, 0c1d) = M(ab, cd)
for a = 1:dim
    for b = 1:dim
        row = (a-1)*dim + b;
        symrow = (a - 1)*2*dim + dim + b;
        for c =1:dim
            for d = 1:dim
                col = (c - 1)*dim + d;
                symcol = (c - 1)*2*dim + dim + d;
                Msym(symrow, symcol) = M(row, col);
            end
        end
    end
end
