function res = calc_residue(indcs, param)
    twi0 = param.twi0;
    ring = insert_segmodels(param.ring0, param.data, param.fam_data, indcs);
    ring = specifics.do_corrections(ring, param.nus, param.orbit);
    [TD, ~] = twissring(ring, 0, 1:length(ring));

    beta = cat(1, TD.beta);
    tw.betax = beta(:,1);
    tw.betay = beta(:,2);

    bbx = (tw.betax-twi0.betax)./twi0.betax;
    bby = (tw.betay-twi0.betay)./twi0.betay;
    avex = trapz(twi0.pos, bbx) / twi0.pos(end);
    avey = trapz(twi0.pos, bby) / twi0.pos(end);
    secx = trapz(twi0.pos, bbx.*bbx) / twi0.pos(end);
    secy = trapz(twi0.pos, bby.*bby) / twi0.pos(end);
    stdx = sqrt(secx - avex*avex) * 100;
    stdy = sqrt(secy - avey*avey) * 100;
    res = [stdx; stdy];
end
