function V = swap(d)
V = zeros(d, d, d, d);
for i=1:d
    V(i,i,i,i) = 1.0;
    for j=(i+1):d
        V(i,j,j,i) = 1.0;
        V(j,i,i,j) = 1.0;
    end
end
V = reshape(V, [d^2, d^2]);