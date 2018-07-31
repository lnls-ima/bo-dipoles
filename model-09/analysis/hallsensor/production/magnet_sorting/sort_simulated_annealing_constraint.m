function idcs = sort_simulated_annealing_constraint(data, idcs)
    setappdata(0, 'stop_now', 0);
    ring0 = sirius_bo_lattice();
    twi0 = calctwiss(ring0);
    nu0 = [twi0.mux(end)/2/pi, twi0.muy(end)/2/pi];

    fam_data = sirius_bo_family_data(ring0);
    orbit.bpm_idx = fam_data.BPM.ATIndex(:);
    orbit.hcm_idx = fam_data.CH.ATIndex(:);
    orbit.vcm_idx = fam_data.CV.ATIndex(:);
    orbit.max_nr_iter = 20;
    orbit.svs = 'all';
    r = calc_respm_cod(ring0, orbit.bpm_idx, orbit.hcm_idx, orbit.vcm_idx);
    orbit.respm = r.respm;

    ring_t = insert_segmodels(ring0, data, fam_data, idcs);
    ring_t = do_corrections(ring_t, nu0, orbit);
    res = calc_residue(ring_t, twi0);
    fprintf('%s : %7.4f\n', 'ini', res);

    for i=1:1000
        idcs_t = change_order(idcs);
        ring_t = insert_segmodels(ring0, data, fam_data, idcs_t);
        ring_t = do_corrections(ring_t, nu0, orbit);
        res_t = calc_residue(ring_t, twi0);
        if res_t < res
            res = res_t;
            idcs = idcs_t;
            fprintf('%03d : %7.4f\n', i, res);
        end
        if getappdata(0, 'stop_now')
            fprintf('Interruped by user at iteration %03d\n', i);
            break;
        end
    end
end

function ring = do_corrections(ring, nus, orbit)
    [ring, ~] = cod_sg(orbit, ring);
%     [ring, ~] = lnls_correct_tunes(ring, nus, {'QF', 'QD'}, 'svd', 'add');
end

% function idcs = change_order(idcs)
%     prm = randperm(50, 2);
%     idcs(prm) = idcs(fliplr(prm));
% end

function idcs = change_order(idcs)
    id = idcs(2);
    prm = randperm(25, 2)*2 - randi([0,1]); %permute odd with odd and even with even
    idcs(prm) = idcs(fliplr(prm));
    idcs = put_sec2_in_place(idcs, id);
end

function idcs = put_sec2_in_place(idcs, id)
    if ~exist('id', 'var'), id = 2; end
    idcs = circshift(idcs, [-find(idcs==id)+2, 0]);
end

function res = calc_residue(ring, twi0)
    [TD, ~] = twissring(ring, 0, 1:length(ring));

    beta = cat(1, TD.beta);
    tw.betax = beta(:,1);
    tw.betay = beta(:,2);
%     co = cat(1,TD.ClosedOrbit);
%     tw.cox  = co(1:4:end);
%     tw.coy  = co(3:4:end);

    bbx = (tw.betax-twi0.betax)./twi0.betax;
    rmsx = sqrt(trapz(twi0.pos, bbx.*bbx)/twi0.pos(end));
    bby = (tw.betay-twi0.betay)./twi0.betay;
    rmsy = sqrt(trapz(twi0.pos, bby.*bby)/twi0.pos(end));
    res = (rmsx + rmsy) * 100;
end
