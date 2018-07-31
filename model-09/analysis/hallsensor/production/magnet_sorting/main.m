function indcs = main()
    % sirius('BO.V04.01');
    data = load_data();

    %%
    indcs.unsorted = data.unsorted;

    meth = {'exc_err'};
    for i=1:length(meth)
        m = meth{i};
        indcs.(m) = sort_simple(data, m, indcs.unsorted);
%         indcs.(m) = sort_by_phase_advance(data, m, indcs.unsorted);
    end

    %% Do Simulated annealing around the sorted solution.
%     indcs.anneal = sort_simulated_annealing(data, indcs.angle);

    %% make plots
    make_plots(indcs, data);
