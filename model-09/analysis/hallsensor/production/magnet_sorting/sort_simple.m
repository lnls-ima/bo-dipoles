function sorted_indcs = sort_simple(data, param, indcs)
    [~, sorted_indcs] = sort(data.(param)(indcs));
    sorted_indcs = indcs(sorted_indcs);
    sorted_indcs = [flipud(sorted_indcs(2:2:end)); sorted_indcs(1:2:end)];
