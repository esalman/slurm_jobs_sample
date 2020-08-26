% Creates plots using the aggregate job output
% @param location of the aggregate csv file
% @return high-quality plots

tic

% includes
addpath( genpath( fullfile('../bin/') ) )

% inputs
outpath = fullfile('../results/');
criteria = {'CalinskiHarabasz', 'DaviesBouldin', 'silhouette'};
K = 2:14;

% load results
cvi = readtable( fullfile( outpath, 'cvi_job_results.csv' ) );

% visualization
figure(1)
for c = 1:length(criteria)
    subplot(3,1,c), plot(K, cvi{strcmp(cvi.criteria, criteria{c}), 2:end}, '-o')
    title([criteria{c} ' index'])
    xlabel('K')
    ylabel('index value')
    grid on
end
set(gcf, 'color', 'w')
export_fig( fullfile(outpath, 'array.png'), '-r300' );

disp('DONE!')
toc

