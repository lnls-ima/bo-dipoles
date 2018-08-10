function sorted_indcs = sort_by_phase_advance(data, param, indcs)
    indcs = sort_simple(data, param, indcs);

    off = 13;  % at each 13 dipoles, the phase advance is 10*pi and
               % at each 26 dipoles, the phase advance is 20*pi

    indcs1 = indcs(1:2:end);
    indcs2 = flipud(indcs(2:2:end));

    indcs11 = indcs1(1:off-2);
    indcs12 = indcs1(off-1);
    indcs13 = indcs1(off:end);
    indcs21 = indcs2(1:off);
    indcs22 = indcs2(off+1);
    indcs23 = indcs2(off+2:end);

    sorted_indcs = [indcs13; indcs21; indcs12; indcs22; indcs23; indcs11];
end
