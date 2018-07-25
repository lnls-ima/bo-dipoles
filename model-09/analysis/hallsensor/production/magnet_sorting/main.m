function [indcs, data, rings] = main()
    % sirius('BO.V04.01');
    ring0 = sirius_bo_lattice();
    data = load_data();

    %% Remove bad dipoles and perform simple sorting
    indcs.unsorted = (1:length(data.angle))';
    [~, dummy] = sort(data.angle);
    idx_rm = 9;  % Remove dipole with small integrated sextupole
    idx_rm = [idx_rm; dummy(1); dummy(end-1:end)];
    [~, ai, ~] = intersect(indcs.unsorted, idx_rm);
    indcs.unsorted(ai) = [];

    meth = {'angle'};
    for i=1:length(meth)
        m = meth{i};
        indcs.(m) = sort_simple(data, m, indcs.unsorted);
%         indcs.(m) = sort_by_phase_advance(data, m, indcs.unsorted);
    end

    %% Do Simulated annealing around the sorted solution.
    indcs.anneal = sort_simulated_annealing(ring0, data, indcs.angle);
    
    %% prepare ring models for output;
    rings = create_rings(indcs, data);
    
    %% make plots
    make_plots(indcs, rings, data);