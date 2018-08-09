function opt = get_params()
    ring0 = sirius_bo_lattice();

    %% take into account new optics to compensate systematic quadrupole strength error of the dipoles:
    qfi = findcells(ring0, 'FamName', 'QF');
    ring0 = setcellstruct(ring0, 'PolynomB', qfi, 1.595, 1, 2);

    params.ring0 = ring0;
    params.twi0 = calctwiss(params.ring0);
    params.nus = [params.twi0.mux(end)/2/pi, params.twi0.muy(end)/2/pi];
    params.data = load_data();

    params.fam_data = sirius_bo_family_data(params.ring0);
    params.orbit.bpm_idx = params.fam_data.BPM.ATIndex(:);
    params.orbit.hcm_idx = params.fam_data.CH.ATIndex(:);
    params.orbit.vcm_idx = params.fam_data.CV.ATIndex(:);
    params.orbit.max_nr_iter = 20;
    params.orbit.svs = 'all';
    r = calc_respm_cod(params.ring0, params.orbit.bpm_idx, params.orbit.hcm_idx, params.orbit.vcm_idx);
    params.orbit.respm = r.respm;

    opt.objective_fun = @specifics.calc_residue;
    opt.objective_data = params;
    opt.small_change = @specifics.change_order;
    opt.random_change = @specifics.permute_randomly;
    opt.Nid = 500;
    opt.Ncut = 2;
    opt.NG = 1000;
    opt.Nobj = 2;
    opt.config0 = [];
    opt.folder = 'Const-run01';
    opt.continue = true;
    opt.arbitrary_initial = false;
    opt.print_info = @specifics.print_info;
    opt.simulanneal_Niter = 1000;
    opt.simulanneal_weight = [1; 1];
end
