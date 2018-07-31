function data = load_data()
    datap = import_readme(fullfile('../', 'README-0991p63A-Zpositive.md'));
    datap.segmodels = cell(size(datap.names));
    for ii=1:length(datap.names)
        name = datap.names{ii};
        filename = fullfile('../', name, 'M1', '0991p63A','z-positive', 'model.out');
        datap.segmodels{ii} = import_model(filename);
    end

    datan = import_readme(fullfile('../', 'README-0991p63A-Znegative.md'));
    datan.segmodels = cell(size(datan.names));
    for ii=1:length(datan.names)
        name = datan.names{ii};
        filename = fullfile('../', name, 'M1', '0991p63A','z-negative', 'model.out');
        datan.segmodels{ii} = import_model(filename);
    end
%     datan = datap;
    
    
    data.names = datap.names;
    data.angle = -datap.angle - datan.angle;
    data.exc_err = data.angle / mean(data.angle) - 1;
    data.int_dip = -datap.int_dip - datan.int_dip;
    data.int_quad = datap.int_quad + datan.int_quad;
    data.int_sext = datap.int_sext + datan.int_sext;

    data.segmodels = cell(size(data.names));
    for i=1:length(datap.segmodels)
        data.segmodels{i} = [fliplr(datan.segmodels{i}), datap.segmodels{i}];
    end

    % Remove bad dipoles
    data.unsorted = (1:length(data.angle))';
    [~, dummy] = sort(data.angle);
    idx_rm = 9;  % Remove dipole with small integrated sextupole
    idx_rm = [idx_rm; dummy(1); dummy(end-1:end)];
    [~, ai, ~] = intersect(data.unsorted, idx_rm);
    data.unsorted(ai) = [];
end


function model = import_model(filename)
    % Initialize variables.
    delimiter = ',';
    startRow = 3;
    endRow = inf;

    % Read columns of data as text:
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%s%s%s%s%s%s%s%s%s%[^\n\r]';
    numericColumns = [1,2,3,4,5,6,7,8,9];
    
    dataArray = read_text_file(filename, delimiter, startRow, endRow, formatSpec);
    raw = import_numeric_data(dataArray, numericColumns);

    %% Creates AT model
    monomials = [0,1,2,3,4,5,6];
    passmethod = 'BndMPoleSymplectic4Pass';
    famname = 'B';

    segmodel = cell2mat(raw);
    
    d2r = (pi/180.0);
    
    %% correct model
    nom_ang = 3.6;
    % segmodel from simulation at High Energy
    segmodel_sim = [ ...
        0.196, +1.15780; 0.192, +1.14328; 0.182, +1.09639; 0.010, +0.05091; ...
        0.010, +0.03671; 0.013, +0.03275; 0.017, +0.02908; 0.020, +0.02233; ...
        0.030, +0.01835; 0.050, +0.01240 ];
    % segmodel from simulation at Low Energy
%     segmodel_sim = [ ...
%         0.196, +1.15700; 0.192, +1.14267; 0.182, +1.09642; 0.010, +0.05151; ...
%      	0.010, +0.03715; 0.013, +0.03295; 0.017, +0.02915; 0.020, +0.02235; ...
%      	0.030, +0.01835; 0.050, +0.01245 ];
    
    dang = segmodel(end, 3) * segmodel(end, 1);
    Tang = nom_ang + dang / d2r;
    seg_ang = segmodel(:,2) * Tang / nom_ang;
    dang = seg_ang - segmodel_sim(:,2);
    dpolB = (dang * d2r) ./ segmodel(:,1);
    segmodel(:,2) = segmodel_sim(:,2);
    segmodel(:,3) = dpolB;
    
    
    %% builds half of the magnet model
    % converts deflection angle from degress to radians
    segmodel(:,2) = segmodel(:,2) * d2r;
    b = zeros(1,size(segmodel,1));
    maxorder = 1+max(monomials);
    for i=1:size(segmodel,1)
        PolyB = zeros(1,maxorder); PolyA = zeros(1,maxorder);
        PolyB(monomials+1) = segmodel(i,3:end);
        b(i) = rbend_sirius(famname, segmodel(i,1), segmodel(i,2), 0, 0, 0, 0, 0, PolyA, PolyB, passmethod);
    end

    % builds entire magnet model, inserting additional markers
    % model_length = 2*sum(segmodel(:,2));
    model = buildlat(b);
end

function data = import_readme(filename)
    % Initialize variables.
    delimiter = {',','|'};
    startRow = 10;
    endRow = inf;

    % Read columns of data as text:
    % For more information, see the TEXTSCAN documentation.
    formatSpec = '%s%s%s%s%s%[^\n\r]';
    numericColumns = [2,3,4,5];
    
    dataArray = read_text_file(filename, delimiter, startRow, endRow, formatSpec);
    raw = import_numeric_data(dataArray, numericColumns);

    % Allocate imported array to column variable names
    data.names = cellfun(@strip, raw(:, 1), 'UniformOutput', false);
    data.angle = cell2mat(raw(:, 2));
    data.int_dip = cell2mat(raw(:, 3));
    data.int_quad = cell2mat(raw(:, 4));
    data.int_sext = cell2mat(raw(:, 5));
end


function dataArray = read_text_file(filename, delimiter, startRow, endRow, formatSpec)
    % Open the text file.
    fileID = fopen(filename,'r');

    % Read columns of data according to the format.
    % This call is based on the structure of the file used to generate this
    % code. If an error occurs for a different file, try regenerating the code
    % from the Import Tool.
    dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    for block=2:length(startRow)
        frewind(fileID);
        dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
        for col=1:length(dataArray)
            dataArray{col} = [dataArray{col};dataArrayBlock{col}];
        end
    end
    % Close the text file.
    fclose(fileID);
end

function raw = import_numeric_data(dataArray, cols)

    % Convert the contents of columns containing numeric text to numbers.
    % Replace non-numeric text with NaN.
    raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
    for col=1:length(dataArray)-1
        raw(1:length(dataArray{col}),col) = dataArray{col};
    end
    numericData = NaN(size(dataArray{1},1),size(dataArray,2));

    for col=cols
        % Converts text in the input cell array to numbers. Replaced non-numeric
        % text with NaN.
        rawData = dataArray{col};
        for row=1:size(rawData, 1)
            % Create a regular expression to detect and remove non-numeric prefixes and
            % suffixes.
            regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
            try
                result = regexp(rawData{row}, regexstr, 'names');
                numbers = result.numbers;

                % Detected commas in non-thousand locations.
                invalidThousandsSeparator = false;
                if any(numbers==',')
                    thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                    if isempty(regexp(numbers, thousandsRegExp, 'once'))
                        numbers = NaN;
                        invalidThousandsSeparator = true;
                    end
                end
                % Convert numeric text to numbers.
                if ~invalidThousandsSeparator
                    numbers = textscan(strrep(numbers, ',', ''), '%f');
                    numericData(row, col) = numbers{1};
                    raw{row, col} = numbers{1};
                end
            catch me
            end
        end
    end
end
