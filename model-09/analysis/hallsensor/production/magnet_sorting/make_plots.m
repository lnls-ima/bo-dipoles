function twi = make_plots(indcs, data)
    rings = create_rings(indcs, data);

    fs = fieldnames(rings);
    for i=1:length(fs)
        m = fs{i};
        twi.(m) = calctwiss(rings.(m));
    end
    %%
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

    for i=1:length(fs)
        m = fs{i};
        tw = twi.(m);
        plot(axs(1), tw.pos, tw.cox*1000, 'LineWidth', 3);
        plot(axs(2), tw.pos, tw.coy*1000, 'LineWidth', 3);
        plot(axs(3), tw.pos, 100*(tw.betax-twi.bare.betax)./twi.bare.betax, 'LineWidth', 3);
        plot(axs(4), tw.pos, 100*(tw.betay-twi.bare.betay)./twi.bare.betay, 'LineWidth', 3);
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
    mk = '+o*xvd^s><';
    for i=1:length(fi)
        plot(ax, 100*data.exc_err(indcs.(fi{i})), mk(mod(i,length(mk))+1), ...
             'MarkerSize', 16, 'MarkerFaceColor','auto', 'DisplayName', fi{i});
    end
    legend(ax, 'Location', 'best');
end
