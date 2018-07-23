function sort_by_phase_advance(data)

dangle = data.angle - 3.6;
[~, idcs] = sort(dangle);

idx_rm = 9;  % Remove dipole with small integrated sextupole
idx_rm = [idx_rm; idcs(1); idcs(end-1:end)];
[~, ai, ~] = intersect(idcs, idx_rm);
idcs(ai) = [];

off = 13;  % at each 13 dipoles, the phase advance is 10*pi
off = 26;  % at each 26 dipoles, the phase advance is 20*pi

unsorted_segmodels = data.segmodels;
unsorted_segmodels(idx_rm) = [];

idcs = [flipud(idcs(2:2:end)); idcs(1:2:end)];
sorted_segmodels = data.segmodels(idcs);