function [indcs, data, ring] = perform_sorting()
    % sirius('BO.V04.01');
    ring.bare = sirius_bo_lattice();
    fam_data = sirius_bo_family_data(ring.bare);

    data = load_data();

    %% Remove bad dipoles and perform simple sorting
    indcs.unsorted = (1:length(data.angle))';
    [~, dummy] = sort(data.angle);
    idx_rm = 9;  % Remove dipole with small integrated sextupole
    idx_rm = [idx_rm; dummy(1); dummy(end-1:end)];
    [~, ai, ~] = intersect(indcs.unsorted, idx_rm);
    indcs.unsorted(ai) = [];
    ring.unsorted = insert_segmodels(ring.bare, data, fam_data, indcs.unsorted);

    meth = {'angle'};
    for i=1:length(meth)
        m = meth{i};
        indcs.(m) = sort_simple(data, m, indcs.unsorted);
%         indcs.(m) = sort_by_phase_advance(data, m, indcs.unsorted);
        ring.(m) = insert_segmodels(ring.bare, data, fam_data, indcs.(m));
    end

    orbit.bpm_idx = fam_data.BPM.ATIndex(:);
    orbit.hcm_idx = fam_data.CH.ATIndex(:);
    orbit.vcm_idx = fam_data.CV.ATIndex(:);
    orbit.max_nr_iter = 20;
    orbit.svs = 'all';
    r = calc_respm_cod(ring.bare, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx);
    orbit.respm = r.respm;

    %% Do Simulated annealing around the sorted solution.

    indcs.anneal = sort_simulated_annealing(ring.bare, data, fam_data, orbit, indcs.angle);
    ring.anneal = insert_segmodels(ring.bare, data, fam_data, indcs.anneal);
    
    %% prepare ring models for output;
    twi0 = calctwiss(ring.bare);
    nux0 = twi0.mux(end)/2/pi;
    nuy0 = twi0.muy(end)/2/pi;
    fs = fieldnames(ring);
    for i=1:length(fs)
        m = fs{i};
%         [ring.(m), ~] = cod_sg(orbit, ring.(m));
%         [ring.(m), ~] = lnls_correct_tunes(ring.(m), [nux0, nuy0], {'QF', 'QD'}, 'svd', 'add');
    end
    
    %% make plots
    make_plots(indcs, ring, data);