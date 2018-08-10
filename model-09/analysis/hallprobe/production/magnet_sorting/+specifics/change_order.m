function idcs = change_order(idcs, params)
    % prm = randperm(50, 2);
    % idcs(prm) = idcs(fliplr(prm));

    % Keep the constraints
    [id1, id2] = find_id1(idcs, params.data);
    if ~id2
        id2 = find_id2(idcs, params.data, id1);
    end
    idcs([id1; id2]) = idcs([id2; id1]);
end

function [id1, id2] = find_id1(idcs, data)
    id1 = randi(50);
    id2 = 0;
    mag = idcs(id1);
    fs = fieldnames(data.sec_types);
    for i=1:length(fs)
        tp = data.sec_types.(fs{i});
        if any(mag == tp.dip_indcs)
            sec = tp.secs(idcs(tp.secs) ~= mag);
            if isempty(sec)
                [id1, id2] = find_id1(idcs, data);
            else
                id2 = sec(randi(length(sec)));
            end
            return
        end
    end
end

function id2 = find_id2(idcs, data, id1)
    id2 = randi(50);
    if id2 == id1
        id2 = find_id2(idcs, data, id1);
    end
    mag = idcs(id2);
    fs = fieldnames(data.sec_types);
    for i=1:length(fs)
        tp = data.sec_types.(fs{i});
        if any(mag == tp.dip_indcs)
            id2 = find_id2(idcs, data, id1);
            return
        end
    end
end
