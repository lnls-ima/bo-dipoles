function indcs = multiobjective_find_results(re, res_max, res_min)
if ~exist('res_min', 'var')
    res_min = res_max*0;
end

fn = fieldnames(re);
fn = fn(1:end-1);
for i=1:length(fn)
    ge = fn{i};
    res = re.(ge).res;
    isols = find(all(res - res_max(:)<=0 & res - res_min(:)>=0 ));
    for j=isols
        el = sprintf('I%03d', j);
        indcs.([ge, el]) = re.indcs.(ge).(el);
    end
end


