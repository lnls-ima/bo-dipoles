r = {};
% r1 = load('comparacao2.mat');
% r1 = r1.resp;
% r = [r,r1];
% r1 = load('comparacao3.mat');
% r1 = r1.resp2;
% r = [r,r1];
% r2 = load('comparacao4.mat');
% r2 = r2.resp;
% r  = [r,r2];
r3 = load('fieldmap_analysis_modelo5_6segmentos.mat');
r3 = r3.r;
r  = [r,r3];
r4 = load('fieldmap_analysis_modelo6_6segmentos.mat');
r4 = r4.r;
r  = [r,r4];

ylabels = {
    'rk_traj - dipole', ...
    'rk_traj - quadrupole', ...
    'rk_traj - sextupole', ...
    'rk_traj - octupole', ...
    'rk_traj - decapole', ...
    'rk_traj - duodecapole', ...
    };

colors = {[1 1/2 0],[0 0 1],[1 0 0],[1 0 1],[0 0 0],[0 1 1],[0 1/2 0]};

for i=1:3
    figure;
    hold on;
    tam = length(r);
    for j=1:tam
        b = r{j}.rk_traj.by_polynom(:,i);
        s = r{j}.rk_traj.s';
        [~,fname] = fileparts(r{j}.parms.fmap_fname);
        plot(1000*s, b, 'Color', colors{mod(j,length(colors))+1}, 'DisplayName',fname(30:45));
        disp(r{j}.rk_traj.angle_x(end)*180/pi)
    end
    xlabel('long. pos [mm]');
    is = int2str(i-1); ylabel(['d^{' is '}B_y/dx^{' is '} [T/m^{' is '}]']);
    set(gcf, 'Name', ['PolynomB - ' ylabels{i}]);
    legend show
end