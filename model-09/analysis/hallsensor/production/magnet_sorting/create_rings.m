function ring = create_rings(indcs, data)
    ring.bare = sirius_bo_lattice();
    fam_data = sirius_bo_family_data(ring.bare);

    orbit.bpm_idx = fam_data.BPM.ATIndex(:);
    orbit.hcm_idx = fam_data.CH.ATIndex(:);
    orbit.vcm_idx = fam_data.CV.ATIndex(:);
    orbit.max_nr_iter = 20;
    orbit.svs = 'all';
    r = calc_respm_cod(ring.bare, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx);
    orbit.respm = r.respm;

    twi0 = calctwiss(ring.bare);
    nux0 = twi0.mux(end)/2/pi;
    nuy0 = twi0.muy(end)/2/pi;
    fs = fieldnames(indcs);
    for i=1:length(fs)
        m = fs{i};
        ring.(m) = insert_segmodels(ring.bare, data, fam_data, indcs.(m));
        [ring.(m), ~] = cod_sg(orbit, ring.(m));
        [ring.(m), ~] = lnls_correct_tunes(ring.(m), [nux0, nuy0], {'QF', 'QD'}, 'svd', 'add');
    end
