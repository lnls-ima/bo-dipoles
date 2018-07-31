function multiobjective_run(data, idcs0, fol, arb_ini)
    if ~exist('fol', 'var')
        fol = '.';
    end
    if ~exist('arb_ini', 'var')
        arb_ini = false;
    end
    if ~exist(fol, 'dir')
        mkdir(fol);
    end
    fol = [fol,'/'];

    setappdata(0, 'stop_now', 0);
    param.ring0 = sirius_bo_lattice();
    param.twi0 = calctwiss(param.ring0);
    param.nus = [param.twi0.mux(end)/2/pi, param.twi0.muy(end)/2/pi];
    param.data = data;
    
    param.fam_data = sirius_bo_family_data(param.ring0);
    param.orbit.bpm_idx = param.fam_data.BPM.ATIndex(:);
    param.orbit.hcm_idx = param.fam_data.CH.ATIndex(:);
    param.orbit.vcm_idx = param.fam_data.CV.ATIndex(:);
    param.orbit.max_nr_iter = 20;
    param.orbit.svs = 'all';
    r = calc_respm_cod(param.ring0, param.orbit.bpm_idx, param.orbit.hcm_idx, param.orbit.vcm_idx);
    param.orbit.respm = r.respm;
        
    Nid = 500;
    Ncut = 3;
    NG = 200;
    Nobj = 2;
    idcs0 = remove_repeated(idcs0);
    sz = size(idcs0,2);
    Gn = zeros(size(idcs0,1), Nid);
    Gn(:, 1:sz) = idcs0;
    if sz < Nid
        for i=sz+1:Nid
            ind = idcs0(:, randi(sz));
            if arb_ini
                Gn(:,i) = permute_randomly(ind);
            else
                Gn(:,i) = change_order(ind);
            end
        end
    end
    Gn = remove_repeated(Gn);
    resn = zeros(Nobj, size(Gn,2));
    for i=1:size(Gn,2)
        resn(:,i) = calc_residue(Gn(:,i), param);
    end
    id_keep = save_best_and_kill_worst(resn, Ncut);
    G = Gn(:,id_keep);
    res = resn(:,id_keep);
    save([fol,'G001.mat'], 'G', 'res');
    fprintf('finish G001 with %03d individuals\n', size(G,2));
   
    
    for i=2:NG
        sz = size(G,2);
        Gn = zeros(size(G,1), sz + Nid);
        Gn(:,1:sz) = G;
        for ii=1:Nid
            ind = G(:, randi(sz));
            Gn(:, sz+ii) = change_order(ind);
        end
        Gn = remove_repeated(Gn);
        resn = zeros(Nobj, size(Gn,2));
        resn(:,1:sz) = res;
        for ii=sz+1:size(Gn,2)
            resn(:, ii) = calc_residue(Gn(:, ii), param);
        end
        id_keep = save_best_and_kill_worst(resn, Ncut);
        G = Gn(:,id_keep);
        res = resn(:,id_keep);
        st = sprintf('G%03d', i);
        save([fol, st, '.mat'], 'G', 'res');
        fprintf('finish %s with %03d individuals. beta = (%5.3f, %5.3f)\n', ...
                st, size(G,2), min(res(1,:)), min(res(2,:)));
        if getappdata(0, 'stop_now')
            fprintf('Interruped by user at generation %03d\n', i);
            break;
        end
    end
end

function indcs = remove_repeated(indcs)
    [~, I] = unique(indcs', 'rows', 'stable');
    indcs = indcs(:,I);
end

function id_keep = save_best_and_kill_worst(res, Ncut)
    ndom = (size(res,2)+1)*ones(size(res,2));
    for i=1:size(res,2)
        dres = res - res(:,i);
        dominate = all(dres < 0);
        ndom(i) = sum(dominate);
    end
    id_keep = find(ndom <= Ncut);
end

function idcs = permute_randomly(idcs)
    id = randperm(50,50);
    idcs = idcs(id);
end

function idcs = change_order(idcs)
    prm = randperm(50, 2);
    idcs(prm) = idcs(fliplr(prm));
end

% function idcs = permute_randomly(idcs)
%     od = randperm(25,25)*2-1;
%     ev = randperm(25,25)*2;
%     id = reshape([od;ev],[],1);
%     id = put_sec2_in_place(id);
%     idcs = idcs(id);
% end
% 
% function idcs = change_order(idcs)
%     id = idcs(2);
%     prm = randperm(25, 2)*2 - randi([0,1]); %permute odd with odd and even with even
%     idcs(prm) = idcs(fliplr(prm));
%     idcs = put_sec2_in_place(idcs, id);
% end

% function idcs = put_sec2_in_place(idcs, id)
%     if ~exist('id', 'var'), id = 2; end
%     idcs = circshift(idcs, [-find(idcs==id)+2, 0]);
% end

function res = calc_residue(indcs, param)
    twi0 = param.twi0;
    ring = insert_segmodels(param.ring0, param.data, param.fam_data, indcs);
    [TD, ~] = twissring(ring, 0, 1:length(ring));

    beta = cat(1, TD.beta);
    tw.betax = beta(:,1);
    tw.betay = beta(:,2);
%     co = cat(1,TD.ClosedOrbit);
%     tw.cox  = co(1:4:end);
%     tw.coy  = co(3:4:end);
    
    bbx = (tw.betax-twi0.betax)./twi0.betax;
    bby = (tw.betay-twi0.betay)./twi0.betay;
    avex = trapz(twi0.pos, bbx) / twi0.pos(end);
    avey = trapz(twi0.pos, bby) / twi0.pos(end);
    secx = trapz(twi0.pos, bbx.*bbx) / twi0.pos(end);
    secy = trapz(twi0.pos, bby.*bby) / twi0.pos(end);
    stdx = sqrt(secx*secx - avex*avex);
    stdy = sqrt(secy*secy - avey*avey);
    res = [stdx; stdy];
end

% function ring = do_corrections(ring, nus, orbit)
%     [ring, ~] = cod_sg(orbit, ring);
% %     [ring, ~] = lnls_correct_tunes(ring, nus, {'QF', 'QD'}, 'svd', 'add');
% end
