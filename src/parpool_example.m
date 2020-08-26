% Performs computation on a node using Matlab parallel pool
% @param 
% @return 

% set path and parse arguments
cores = 4;

% includes
addpath( fullfile('../bin/altmany-export_fig-9676767/') )

% inputs
data_path = fullfile('../data/');
outpath = fullfile('../results/');
criteria = {'CalinskiHarabasz', 'DaviesBouldin', 'silhouette'};
K = 2:14;
limit_rows = 1000;

% load data
dfnc = csvread( fullfile(data_path, '/dfnc.csv') );
dfnc = dfnc(1:limit_rows, :);
% compute indices
cvi = NaN * ones( length(criteria), length(K) );
delete(gcp('nocreate'))
parpool(cores)
tic
for c = 1:length(criteria)
    parfor i = 1:length(K)
        cvi(c, i) = compute_cvi(dfnc, K(i), criteria{c}, data_path, limit_rows);
    end
end
toc

% visualization
figure(1)
for c = 1:length(criteria)
    subplot(3,1,c), plot(K, cvi(c,:), '-o')
    title([criteria{c} ' index'])
    xlabel('K')
    ylabel('index value')
    grid on
end
set(gcf, 'color', 'w')
export_fig( fullfile(outpath, 'parpool.png'), '-r300' );
disp('DONE!')

function ret = compute_cvi(data, k, criteria, data_path, limit_rows)
    labels = csvread( fullfile(data_path, ['label_' num2str(k) '.csv']) );
    labels = labels( 1:limit_rows );
    disp(['evaluating ' criteria ' for K=' num2str(k)])
    t1 = evalclusters(data, labels, criteria);
    ret = t1.CriterionValues;
    disp(['cvi = ' num2str(ret)])
end

