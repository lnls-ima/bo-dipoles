function sorted_indcs = sort_simple(data, param, indcs)
    [~, sorted_indcs] = sort(data.(param)(indcs));
    sorted_indcs = indcs(sorted_indcs);
    sorted_indcs = [flipud(sorted_indcs(2:2:end)); sorted_indcs(1:2:end)];
    
%     % if you want more oscillation periods
%     for i=1:3
%         sorted_indcs = [flipud(sorted_indcs(2:2:end)); sorted_indcs(1:2:end)];
%     end
