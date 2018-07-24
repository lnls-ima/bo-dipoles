% sirius('BO.V04.01');
ring0 = sirius_bo_lattice();
fam_data = sirius_bo_family_data(ring0);

data = import_readme(fullfile('../', 'README.md'));
data.segmodels = cell(size(data.names));
for ii=1:length(data.names)
    name = data.names{ii};
    filename = fullfile('../', name, 'M1', '0991p63A', 'model.out');
    data.segmodels{ii} = import_model(filename);
end

%%
[segmodels_u, segmodels_s] = sort_by_angle(data);
% [segmodels_u, segmodels_s] = sort_by_phase_advance(data);
ring_u = insert_segmodels(ring0, segmodels_u, fam_data);
ring_s = insert_segmodels(ring0, segmodels_s, fam_data);

twi0 = calctwiss(ring0);
twi_u = calctwiss(ring_u);
twi_s = calctwiss(ring_s);

%%
nux0 = twi0.mux(end)/2/pi;
nuy0 = twi0.muy(end)/2/pi;
[ring_uc, ~] = lnls_correct_tunes(ring_u, [nux0, nuy0], {'QF', 'QD'}, 'svd', 'add');
[ring_sc, ~] = lnls_correct_tunes(ring_s, [nux0, nuy0], {'QF', 'QD'}, 'svd', 'add');
twi_uc = calctwiss(ring_uc);
twi_sc = calctwiss(ring_sc);


%%
% close all;

figure('Position', [100, 10, 1200, 2000]);
ax = subplot(3, 1, 1);
hold(ax, 'all');
grid(ax, 'on');
box(ax, 'on');
xlabel('position [m]');
ylabel('Horizontal Orbit [mm]');
plot(twi0.pos, twi0.cox*1000, 'b', 'LineWidth', 3);
plot(twi_uc.pos, twi_uc.cox*1000, 'r', 'LineWidth', 3);
plot(twi_sc.pos, twi_sc.cox*1000, 'c', 'LineWidth', 3);
plot(twi_u.pos, twi_u.cox*1000, '--r', 'LineWidth', 2);
plot(twi_s.pos, twi_s.cox*1000, '--c', 'LineWidth', 2);

ax = subplot(3, 1, 2);
hold(ax, 'all');
grid(ax, 'on');
box(ax, 'on');
xlabel('position [m]');
ylabel('Horizontal beta beat [%]');
plot(twi_uc.pos, 100*(twi_uc.betax-twi0.betax)./twi0.betax, 'r', 'LineWidth', 3);
plot(twi_sc.pos, 100*(twi_sc.betax-twi0.betax)./twi0.betax, 'c', 'LineWidth', 3);
plot(twi_u.pos, 100*(twi_u.betax-twi0.betax)./twi0.betax, '--r', 'LineWidth', 2);
plot(twi_s.pos, 100*(twi_s.betax-twi0.betax)./twi0.betax, '--c', 'LineWidth', 2);
labels = {'Unsorted w Tune Corr', 'Sorted w/ Tune Corr', ...
          'Unsorted w/o Tune Corr', 'Sorted w/o Tune Corr'};
legend('best', labels);

ax = subplot(3, 1, 3);
hold(ax, 'all');
grid(ax, 'on');
box(ax, 'on');
xlabel('position [m]');
ylabel('Vertical beta beat [%]');
plot(twi_uc.pos, 100*(twi_uc.betay-twi0.betay)./twi0.betay, 'r', 'LineWidth', 3);
plot(twi_sc.pos, 100*(twi_sc.betay-twi0.betay)./twi0.betay, 'c', 'LineWidth', 3);
plot(twi_u.pos, 100*(twi_u.betay-twi0.betay)./twi0.betay, '--r', 'LineWidth', 2);
plot(twi_s.pos, 100*(twi_s.betay-twi0.betay)./twi0.betay, '--c', 'LineWidth', 2);

qd_idx = findcells(ring0, 'FamName', 'QD');
qf_idx = findcells(ring0, 'FamName', 'QF');
qd0 = getcellstruct(ring0, 'PolynomB', qd_idx(1), 1, 2);
qf0 = getcellstruct(ring0, 'PolynomB', qf_idx(1), 1, 2);
qd_uc = getcellstruct(ring_uc, 'PolynomB', qd_idx(1), 1, 2);
qf_uc = getcellstruct(ring_uc, 'PolynomB', qf_idx(1), 1, 2);
qd_sc = getcellstruct(ring_sc, 'PolynomB', qd_idx(1), 1, 2);
qf_sc = getcellstruct(ring_sc, 'PolynomB', qf_idx(1), 1, 2);

nux_uc = twi_uc.mux(end)/2/pi;
nuy_uc = twi_uc.muy(end)/2/pi;
nux_sc = twi_sc.mux(end)/2/pi;
nuy_sc = twi_sc.muy(end)/2/pi;

fmt = 'nu = (%6.3f, %6.3f), xi = (%5.3f, %5.3f), qd = %6.3f,  qf = %6.3f\n';
fprintf(['original: ', fmt], ...
        nux0, nuy0, twi0.chromx, twi0.chromy, qd0, qf0);
fprintf(['unsorted: ', fmt], ...
        nux_uc, nuy_uc, twi_uc.chromx, twi_uc.chromy, qd_uc, qf_uc);
fprintf(['sorted:   ', fmt], ...
        nux_sc, nuy_sc, twi_sc.chromx, twi_sc.chromy, qd_sc, qf_sc);

