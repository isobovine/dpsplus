%function plot_curves()
load('output/curves-last.mat');

clf;

descs = cell(size(levels));
vals = zeros(2*length(levels), length(gammas));

%plot all levels on the same plot

for l = 1:length(levels)
    level = levels(l);
    descs{l * 2 - 1} = sprintf('with KKT level %d', level);
    descs{l * 2} = sprintf('without KKT level %d', level);
end

vals(1:2:2*length(levels)-1, :) = hvals_dpsplus;
vals(2:2:2*length(levels), :) = hvals_dps;

plot(gammas, vals);

h= legend(descs);
set(h,'FontSize',14);
xlabel('$\gamma$', 'interpreter', 'latex', 'FontSize', 16);
ylabel('estimate of $h_{\mathrm{ProdSym}}$', 'interpreter', 'latex', 'FontSize', 16);
title('Comparing the DPS and DPS+KKT hierarchies', 'FontSize', 14);

print -dpng -r300 'output/numerical_results.png'

%plot each level on a separate plot

for l = 1:length(levels)
    level = levels(l);
    descs_level = cell([1,2]);
    descs_level{1} = descs{l*2-1};
    descs_level{2} = descs{l*2};
    vals_level(1,:) = vals(2*l - 1, :);
    vals_level(2,:) = vals(2*l, :);
    plot(gammas, vals_level);
    h= legend(descs_level);
    set(h,'FontSize',14);
    xlabel('$\gamma$', 'interpreter', 'latex', 'FontSize', 16);
    ylabel('estimate of $h_{\mathrm{ProdSym}}$', 'interpreter', 'latex', 'FontSize', 16);
    title('Comparing the DPS and DPS+KKT hierarchies', 'FontSize', 14);
    filename = sprintf('output/numerical_results_level_%d.png', ...
                              level);
    print(filename, '-dpng', '-r600');
end
