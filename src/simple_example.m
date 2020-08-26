% performs computation on a core
% @param
% @return

% set path and parse arguments

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
tic
for c = 1:length(criteria)
    for i = 1:length(K)
        labels = csvread( fullfile(data_path, ['label_' num2str(K(i)) '.csv']) );
        labels = labels( 1:limit_rows );
        disp(['evaluating ' criteria{c} ' for K=' num2str(K(i))])
        t1 = evalclusters(dfnc, labels, criteria{c});
        cvi(c, i) = t1.CriterionValues;
        disp(['cvi = ' num2str(cvi(c, i))])
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
export_fig(fullfile(outpath, 'simple.png'), '-r300');

disp('DONE!')
