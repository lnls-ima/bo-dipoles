function [unsorted_segmodels, sorted_segmodels] = sort_by_angle(data)

[~, idcs] = sort(data.angle);

idx_rm = 9;  % Remove dipole with small integrated sextupole
idx_rm = [idx_rm; idcs(1); idcs(end-1:end)];
[~, ai, ~] = intersect(idcs, idx_rm);
idcs(ai) = [];

unsorted_segmodels = data.segmodels;
unsorted_segmodels(idx_rm) = [];

idcs = [flipud(idcs(2:2:end)); idcs(1:2:end)];
sorted_segmodels = data.segmodels(idcs);