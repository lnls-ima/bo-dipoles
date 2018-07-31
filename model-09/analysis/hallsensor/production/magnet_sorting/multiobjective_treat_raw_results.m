function res = multiobjective_treat_raw_results(fol)
    if ~exist('fol', 'var')
        fol = '.';
    end
    if ~exist(fol, 'dir')
        error(['Folder ', fol, 'do not exist in current directory']);
    end
    fol = [fol,'/'];
    
    res = struct();

    Gen = regexp(ls(fol, '-rt'), 'G[0-9]{3}', 'match');
    Gen = sort(Gen);
    for i=1:length(Gen)
        st = Gen{i};
        res.(st) = load([fol, st,'.mat']);
    end
    
    % remove bad results
    Ncut = 5;
    Gen = fieldnames(res);
    for i=1:length(Gen)
        G = res.(Gen{i});
        id_keep = save_best_and_kill_worst(G.res, Ncut);
        G.res = G.res(:,id_keep);
        G.G = G.G(:,id_keep);
        res.(Gen{i}) = G;
    end    
    
    % remove duplicated results
    for i=1:length(Gen)
        G = res.(Gen{i}).G;
        [~, I] = unique(G', 'rows', 'stable');
        res.(Gen{i}).G = G(:,I);
        res.(Gen{i}).res = res.(Gen{i}).res(:,I);
        for ii=i+1:length(Gen)
            G2 = res.(Gen{ii}).G;
            ind = [];
            for j=1:size(G,2)
                ind = [ind, find(all(G(:,j) == G2))];
            end
            res.(Gen{ii}).G(:, ind) = [];
            res.(Gen{ii}).res(:,ind) = [];
        end
    end
    % transform indices to fields
    for i=1:length(Gen)
        G = res.(Gen{i}).G;
        if isempty(G)
            res = rmfield(res, Gen{i});
            continue;
        end
        for j=1:size(G,2)
            res.indcs.(Gen{i}).(sprintf('I%03d',j)) = G(:,j);
        end
    end
end

function id_keep = save_best_and_kill_worst(res, Ncut)
%     % this is the wrong way of doing it!
%     [~, id1] = sort(res(1,:));
%     [~, id2] = sort(res(2,:));
%     id_keep = unique([id1(1:Ncut),id2(1:Ncut)]);

    % this is the correct way:
    ndom = (size(res,2)+1)*ones(size(res,2));
    for i=1:size(res,2)
        dres = res - res(:,i);
        dominate = all(dres < 0);
        ndom(i) = sum(dominate);
    end
    id_keep = find(ndom < Ncut);
end