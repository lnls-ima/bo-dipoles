function compare_results(indcs, opt)
    params = opt.objective_data;
    
    fs = fieldnames(indcs);
    
    alin = @(x,y) strjust(sprintf(x, y), 'center');
    fprintf(alin('%15s', 'Indices'));
    fprintf('\n');
    
    fmt = '| %5.3f  %5.3f ';
    for ii=1:length(fs)
        fprintf(alin('%15s', fs{ii}));
        r = specifics.calc_residue(indcs.(fs{ii}), params);
        fprintf(fmt, r(1), r(2));
        fprintf('\n');
    end
end