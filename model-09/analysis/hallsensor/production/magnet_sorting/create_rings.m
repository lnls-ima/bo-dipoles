function ring = create_rings(indcs, data)
    params = specifics.get_params();
    params = params.objective_data;
    ring.bare = params.ring0;

    fs = fieldnames(indcs);
    for i=1:length(fs)
        m = fs{i};
        ring.(m) = insert_segmodels(ring.bare, data, params.fam_data, indcs.(m));
        ring.(m) = specifics.do_corrections(ring.(m), params.nus, params.orbit);
    end
end
