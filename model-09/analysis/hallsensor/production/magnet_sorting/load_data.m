function data = load_data()
    datap = import_readme(fullfile('../', 'README-991p73A-ZPositive.md'));
    datap.segmodels = cell(size(datap.names));
    for ii=1:length(datap.names)
        name = datap.names{ii};
        filename = fullfile('../', name, 'M1', '0991p63A','z-positive', 'model.out');
        datap.segmodels{ii} = import_model(filename);
    end
    
    datan = import_readme(fullfile('../', 'README-991p73A-ZNegative.md'));
    datan.segmodels = cell(size(datan.names));
    for ii=1:length(datan.names)
        name = datan.names{ii};
        filename = fullfile('../', name, 'M1', '0991p63A','z-negative', 'model.out');
        datan.segmodels{ii} = import_model(filename);
    end
    
    data.names = datap.names;
    data.angle = datap.angle + datan.angle;
    data.int_dip = datap.int_dip + datan.int_dip;
    data.int_quad = datap.int_quad + datan.int_quad;
    data.int_sext = datap.int_sext + datan.int_sext;
    data.rx_init = datap.rx_init;
    
    data.segmodels = cell(size(data.names));
    for i=1:length(datap.segmodels)
        data.segmodels{i} = [fliplr(datan.segmodels{i}), datap.segmodels{i}];
    end