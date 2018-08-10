function sorted_indcs = sort_simple(data, param, indcs)
    % without Constraint
%     [~, sorted_indcs] = sort(data.(param)(indcs));
%     sorted_indcs = indcs(sorted_indcs);
%     sorted_indcs = [flipud(sorted_indcs(2:2:end)); sorted_indcs(1:2:end)];

    % With constraint
    [~, sorted_indcs] = sort(data.(param)(indcs));
    sorted_indcs = [flipud(sorted_indcs(2:2:end)); sorted_indcs(1:2:end)];
    fs = fieldnames(data.sec_types);
    for i=1:length(fs)
        m = fs{i};
        tp = data.sec_types.(m);
        secs = tp.secs;
        for ii=1:length(tp.dip_indcs)
            id1 = find(indcs(sorted_indcs) == tp.dip_indcs(ii));
            [~, I] = min(abs(id1 - secs));
            id2 = secs(I);
            secs(I) = [];
            sorted_indcs([id1;id2]) = sorted_indcs([id2;id1]);
        end
    end
    sorted_indcs = indcs(sorted_indcs);
end