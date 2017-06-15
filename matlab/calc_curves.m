function calc_curves()
% computes values of DPS and DPS+KKT for the example from the DPS paper
% saves results to curves.mat

mset('yalmip', true);
mset(sdpsettings('solver','sedumi')); % set your favorite solver here
Z = eye(9) - dps_example_one();
levels = [1,2]; % run at lowest level
gammas=0.01:0.01:0.07;
%gammas = [0.01];

%value computed by DPS with KKT
hvals_dpsplus = zeros(length(levels), length(gammas));

% value computed by DPS
hvals_dps = zeros(length(levels), length(gammas)); 

% top eigenvalue of the measurement on the symmetric subspace
top_eigenvals = zeros(1, length(gammas)); 

% projector onto symmetric subspace - unused
projsym = (eye(36) + swap(6))/2; 


for l = 1:length(levels)
    level = levels(l);
    for n = 1:length(gammas)
        %scale = gammas(n)^2;
        scale = 1.0;
        Agamma = diag([1, ones(1, 2)*gammas(n)])
        Zgamma = kron(inv(Agamma), eye(3)) * Z * kron(inv(Agamma), eye(3));
        %Mgamma_matrix = 0.0*eye(36)+sep_to_prodsym(3, scale * (eye(9)- Zgamma));
        Mgamma_matrix = sep_to_prodsym(3,  (eye(9) - Zgamma));
        top_eigenvals(1, n) = max(eig(projsym*Mgamma_matrix*projsym));
        Mgamma = reshape(Mgamma_matrix, [6,6,6,6]);
        [hval_dpsplus, hval_dps] = hprodsym_yalmip_sos(Mgamma_matrix, level);
        % factor of 4 from hsep->hprodsym reduction
        hvals_dpsplus(l, n) = (4/scale)*hval_dpsplus; 
        hvals_dps(l, n) = (4/scale)*hval_dps;
        %hvals_dpsplus(l, n) = 4*hval_dpsplus; 
        %hvals_dps(l, n) = 4*hval_dps;
    end
end

status = mkdir('output');
save('output/curves-last.mat', 'levels', 'gammas', 'hvals_dps', 'hvals_dpsplus', ...
     'top_eigenvals');
save(['output/curves-' datestr(now, 'yymmdd-HHMMSS') '.mat'], 'levels', ...
     'gammas', 'hvals_dps', 'hvals_dpsplus', 'top_eigenvals');

