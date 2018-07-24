function [unsorted_segmodels, sorted_segmodels] = sort_by_phase_advance(data)
dangle = data.angle - 3.6;
[~, idcs] = sort(dangle);

idx_rm = 9;  % Remove dipole with small integrated sextupole
idx_rm = [idx_rm; idcs(1); idcs(end-1:end)];
[~, ai, ~] = intersect(idcs, idx_rm);
idcs(ai) = [];

off = 13;  % at each 13 dipoles, the phase advance is 10*pi and
           % at each 26 dipoles, the phase advance is 20*pi

idcs1 = idcs(1:2:end);
idcs2 = flipud(idcs(2:2:end));

idcs11 = idcs1(1:off-2);
idcs12 = idcs1(off-1);
idcs13 = idcs1(off:end);
idcs21 = idcs2(1:off);
idcs22 = idcs2(off+1);
idcs23 = idcs2(off+2:end);

idcs_n = [idcs13; idcs21; idcs12; idcs22; idcs23; idcs11];

unsorted_segmodels = data.segmodels;
unsorted_segmodels(idx_rm) = [];

sorted_segmodels = data.segmodels(idcs_n);