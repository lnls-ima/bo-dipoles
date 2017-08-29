clear all;
r = {};
r1 = load('modelo5_0.mat');
r1 = r1.r;
r  = [r,r1];
r1 = load('modelo5_1.mat');
r1 = r1.r;
r = [r,r1];
r1 = load('modelo5_2.mat');
r1 = r1.r;
r = [r,r1];
r1 = load('modelo5_3.mat');
r1 = r1.r;
r  = [r,r1];
r1 = load('modelo5_4.mat');
r1 = r1.r;
r  = [r,r1];
r1 = load('modelo5_5.mat');
r1 = r1.r;
r  = [r,r1];
r1 = load('modelo5_6.mat');
r1 = r1.r;
r  = [r,r1];


ylabels = {
    'dipole', ...
    'quadrupole', ...
    'sextupole', ...
    'octupole', ...
    'decapole', ...
    'duodecapole', ...
    };

colors = {[1 1/2 0],[0 0 1],[1 0 0],[1 0 1],[0 0 0],[0 1 1],[0 1/2 0]};


tam = length(r);
for j=1:tam
    I(j)       = r{j}.fieldmaps{1}.magnet.submagnets.current;
    energy(j)  = r{j}.parms.beam.energy;
    intB(j,:)  = r{j}.rk_traj_parms.integ_by_polynom(1:3);
    tracy_coe(j,:) = r{j}.rk_traj_parms.tracy_multipoles_polynomB(1:3);
    ang_def(j) = (180/pi)*abs(2*r{j}.rk_traj.angle_x(end));
end

ref_current_idx = 2;
var_per = 100*(tracy_coe - repmat(tracy_coe(ref_current_idx,:),length(tracy_coe(:,1)),1))./repmat(tracy_coe(ref_current_idx,:),length(tracy_coe(:,1)),1);



figure1 = figure('Position',[233 90 977 769]);
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes1,'on');
hold(axes1,'all');
for ii=1:length(var_per(1,:))
    plot(I,var_per(:,ii)','MarkerSize',15,'Marker','.',...
        'Color', colors{mod(ii,length(colors))+1}, 'DisplayName',ylabels{ii});
end
xlabel('Current [A]');
ylabel('Normalized multipole current variation [%]','FontSize',16);
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.441978907735048 0.730472862096722 0.157113613101331 0.113459037711313]);


figure1 = figure('Position',[273 90 977 769]);
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','FontSize',16);
box(axes1,'on');
hold(axes1,'all');
plot(I,100*(ang_def-ang_def(ref_current_idx))/ang_def(ref_current_idx),'MarkerSize',15,'Marker','.');
xlabel('Current [A]','FontSize',16);
ylabel('Dipole deflection angle current variation [%]','FontSize',16);

