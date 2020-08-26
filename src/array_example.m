% Grabs a task_id from SLURM job array and executes it
% @param task_id
% @return task result written to a csv file in the job output folder
% $ sbatch --array=1-39 JobSubmitArray

function array_example(task_id) 
    % set path and parse arguments
    
    % inputs
    data_path = fullfile('../data/');
    outpath = fullfile('../results/cvi_job_outputs/');
    criteria = {'CalinskiHarabasz', 'DaviesBouldin', 'silhouette'};
    K = 2:14;
    limit_rows = 1000;

    if ~exist( outpath, 'dir' )
        mkdir( outpath );
    end

    % load data
    dfnc = csvread( fullfile(data_path, '/dfnc.csv') );
    dfnc = dfnc(1:limit_rows, :);
    % construct a grid
    tic
    [X, Y] = meshgrid( 1:length(criteria), 1:length(K) );
    grid_ = [X(:), Y(:)];
    % compute index
    cvi = compute_cvi(dfnc, K( grid_(task_id, 2) ), criteria{ grid_(task_id, 1) }, data_path, limit_rows);
    disp(['cvi = ' num2str(cvi)])
    
    % log result
    t1 = {task_id, K( grid_(task_id, 2) ), criteria{ grid_(task_id, 1) }, cvi};
    t1 = cell2table(t1, 'VariableNames', {'task_id', 'K', 'criteria', 'cvi'});
    writetable( t1, fullfile(outpath, ['cvi_' num2str(task_id) '.csv']) )
    toc
    
    disp('DONE!')
end

function ret = compute_cvi(data, k, criteria, data_path, limit_rows)
    labels = csvread( fullfile(data_path, ['label_' num2str(k) '.csv']) );
    labels = labels( 1:limit_rows );
    disp(['evaluating ' criteria ' for K=' num2str(k)])
    t1 = evalclusters(data, labels, criteria);
    ret = t1.CriterionValues;
end

