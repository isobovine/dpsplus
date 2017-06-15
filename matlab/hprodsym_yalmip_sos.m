function [ optval_dpsprime, optval_dps ] = hprodsym_yalmip_sos(M, level )
%UNTITLED Summary of this function goes here
%   Solves DPS and DPSplus at SOS degree = 4 + 2 * (level - 1)

d = sqrt(size(M,1));
x = sdpvar(d, 1);
xx = kron(x, x);
f = xx' * M * xx;
normsq = sum(x.*x);
g = 1.0 - normsq;
% DPS
sdpvar gam; 
F = sos((gam * normsq^2 - f)*normsq^((level - 1)));
solvesos(F, gam, sdpsettings('solver','mosek'), [gam]);
optval_dps = value(gam);
% DPS+
nkkt = 1;
nconst = 1;
epsilon = 1e-4;
%epsilon 
Fplus = [];
for ii = 1:d
    for jj = (ii+1):d
        kktpoly(nkkt) = jacobian(f,x(ii)) * jacobian(g, x(jj)) - ...
            jacobian(f, x(jj))*jacobian(g, x(ii));
        % to represent the soft constraint -eps <= kkt <= eps, use two
        % inequality constraints
        % kkt + eps >= 0 and eps - kkt >= 0
        % each kkt constraint has degree 4, so multipliers have
        % degree 2*(level -1)
        [p1, c1] = polynomial(x, 2*(level - 1)); 
        kktmult(nconst) = p1;
        kktmult_coeff(nconst,:) = c1;
        kktconst(nconst) = kktpoly(nkkt) + epsilon;
        Fplus = [Fplus, sos(p1)];
        nconst = nconst + 1;
        [p2, c2] = polynomial(x, 2*(level - 1)); 
        kktmult(nconst) = p2;
        kktmult_coeff(nconst,:) = c2;
        kktconst(nconst) = epsilon - kktpoly(nkkt);
        Fplus = [Fplus, sos(p2)];
        nconst = nconst + 1;
        nkkt = nkkt + 1;
    end
end
sdpvar gamplus;
Fplus = [Fplus, sos((gamplus * normsq^2 - f)*normsq^((level - 1)) - kktconst * ...
            kktmult')];
solvesos(Fplus, gamplus, sdpsettings('solver', 'mosek'), [gamplus; kktmult_coeff(:)]);
optval_dpsprime = value(gamplus);

end

