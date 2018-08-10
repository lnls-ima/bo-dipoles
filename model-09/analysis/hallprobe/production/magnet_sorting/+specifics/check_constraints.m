function check_constraints(indcs, data)

fs = fieldnames(data.sec_types);
for i=1:length(fs)
    tp = data.sec_types.(fs{i});
    a = setdiff(tp.dip_indcs, indcs(tp.secs));
    if ~isempty(a)
        fprintf('not ok\n');
        return;
    end
end

fprintf('ok\n');