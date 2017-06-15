% This is an example where DPS with KKT outperforms DPS.
% This script implements the DPS and DPS+KKT hierarchies over a
% real vector space, for a family of measurements introduced by [DPS'03].

setup;        % set up paths
calc_curves;  % run DPS and DPS+KKT hierarchies and save results to curves.mat
plot_curves;  % plot results and create numerical_results.png