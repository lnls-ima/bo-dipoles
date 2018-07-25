function twi = make_plots(indcs, ring, data)

    fs = fieldnames(ring);
    for i=1:length(fs)
        m = fs{i};
        twi.(m) = calctwiss(ring.(m));
    end

    %%
    % close all;

    figure('Position', [100, 10, 1200, 2000]);
    axs(1) = subplot(4, 1, 1);
    axs(2) = subplot(4, 1, 2);
    axs(3) = subplot(4, 1, 3);
    axs(4) = subplot(4, 1, 4);
    for i=1:length(axs)
        ax = axs(i);
        set(ax, 'Box', 'on', 'FontSize', 16, ...
                'XGrid', 'on', 'YGrid', 'on', 'NextPlot', 'add');
        xlabel(ax, 'position [m]', 'FontSize', 16);
    end


    fmt = '%10s ->   nu = (%6.3f, %6.3f), xi = (%5.3f, %5.3f), qd = %6.3f,  qf = %6.3f\n';
    for i=1:length(fs)
        m = fs{i};
        tw = twi.(m);
        plot(axs(1), tw.pos, tw.cox*1000, 'LineWidth', 3);
        plot(axs(2), tw.pos, tw.coy*1000, 'LineWidth', 3);
        plot(axs(3), tw.pos, 100*(tw.betax-twi.bare.betax)./twi.bare.betax, 'LineWidth', 3);
        plot(axs(4), tw.pos, 100*(tw.betay-twi.bare.betay)./twi.bare.betay, 'LineWidth', 3);

        nux = tw.mux(end)/2/pi;
        nuy = tw.muy(end)/2/pi;
        qd_idx = findcells(ring.(m), 'FamName', 'QD');
        qf_idx = findcells(ring.(m), 'FamName', 'QF');
        qd = getcellstruct(ring.(m), 'PolynomB', qd_idx(1), 1, 2);
        qf = getcellstruct(ring.(m), 'PolynomB', qf_idx(1), 1, 2);
        fprintf(fmt, m, nux, nuy, tw.chromx, tw.chromy, qd, qf);
    end

    ylabel(axs(1), 'Horizontal Orbit [mm]');
    ylabel(axs(2), 'Vertical Orbit [mm]');
    ylabel(axs(3), 'Horizontal beta beat [%]');
    ylabel(axs(4), 'Vertical beta beat [%]');

    legend(axs(2), 'best', fs);

    %%
    figure('Position', [1300, 10, 1200, 1200]);
    ax = axes('FontSize', 16, 'Box', 'on', 'FontSize', 16, ...
              'XGrid', 'on', 'YGrid', 'on', 'NextPlot', 'add');
    xlabel(ax, 'position [m]', 'FontSize', 16);
    ylabel(ax, 'Exc. Error [%]', 'FontSize', 16);
    fi = fieldnames(indcs);
    mk = {'+', '*', '.'};
    for i=1:length(fi)
        plot(ax, 100*data.angle(indcs.(fi{i})), mk{i}, 'MarkerSize', 16, ...
             'MarkerFaceColor','auto', 'DisplayName', fi{i});
    end
    legend(ax, 'Location', 'best');
