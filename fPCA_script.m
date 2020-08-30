clear
addpath(genpath('FELICITY_Ver1.3.1'))

% This line sets the path of the template mesh, .vtk file format
path_manifold = 'stem_smooth/stem_smooth.vtk';
% This line sets the path of the collection of functions, (.csv file format), where each row contains the data of
% one subject. Element jth of the row contains the value of the function on
% the jth vertex of the mesh loaded as a .vtk
path_functions = 'stem_smooth/functional_values.csv';


% Reads the template mesh
manifold = [];
[manifold.vertices, manifold.faces] = read_vtk_el(path_manifold);
% Reads the functional value. 2nd argument is the first valid row in the
% csv file. 3rd argument is the first valid column in the csv file (to skip
% titles)
X = csvread(path_functions, 1, 0);

% Compute mean and remove it from the dataset
X_bar = mean(X);
X_0 = X - ones(size(X,1),1)*X_bar;

% Compute the FE discretization matrices R0 and R1 in the paper
% Relies on Felicity library
[R0,R1] = computeFEM(manifold);
%% Demonstrative computation of the first PC function only
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Computation of first PC %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define parameters sequence
Kfolds = 5; % Number of partitions used in cross-validation to find optimal weight of regularizing term $\lambda$
niter = 20; % Number of iteration
loglambdaseq = -5:1:5; % Sequence of possible values of log($\lambda$) used by cross-validation to select 
                       % the optimum regularizing weight.
                       % Note that the values of $\lambda$ will be 10^(loglambdaseq)
index_NA = []; %indices of the vertices with missing data (set empty, no missing data)

% Compute solution for each possible lambda in 'loglambdaseq'
CVseq1 = fPCAManifold_Kfold(X_0, R0, R1, loglambdaseq, Kfolds, niter, index_NA);
% Find the index of the lambda that minimizes the Cross-Validation error;
% OSS: if index is 1 or equal to size of vector, we should enlarge the set
% of possible $lambda$s
[CV_min1,CV_min_index1] = min(CVseq1);
% Compute solution associated to that lambda
[f1,u1] = fPCAManifold(X_0, R0, R1, loglambdaseq(CV_min_index1), niter, index_NA);
% f1 first PC function (equivalent to PC loadings in classic PCA)
% u1 PC scores (the quantities to use for dim reduction)

%% %% Demonstrative computation of the first N_PC PC function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Computation of first n PC %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define parameters sequence
Kfolds = 3; % Number of partitions used in cross-validation to find optimal weight of regularizing term $lambda$
niter = 20; % Number of iteration
loglambdaseq = -6:1:10; % Sequence of possible values of log($lambda$) wherre the optimal is sought
                       %Note inside the function the value of lambdas will
                       %be 10^(loglambdaseq)
index_NA = []; %indices of with missing data (set empty, no missing data)

N_PC = 20; %Number of PC to be computed

F_not_normalized = zeros(N_PC, size(X_0,2)); % matrix containg un-normalized PC functions (ith PC function in ith row)
                              % This matrix will be used to Viusliaze the
                              % meaning of the PC functions
U_normalized = zeros(size(X_0,1), N_PC); % matrix containg normalized PC scores (each PC score vector has norm 1) (ith PC scores vector in ith column)
                              % This matrix will be used as it as a
                              % Reposnse matrix o Design matrix depending
                              % on the rest of the analysis
optimal_lambdas_indices = zeros(N_PC,1); %ith element represent the lambda chosen for the computation of the ith PC

X_residuals = X_0;
for k = 1:N_PC
    disp(['Computing PC function' num2str(k) '...'])
    CVseq = fPCAManifold_Kfold(X_residuals, R0, R1, loglambdaseq, Kfolds, niter, index_NA);
    [CV_min,CV_min_index] = min(CVseq);
    disp(['    Index chosen: ' num2str(CV_min_index) '.'])
    optimal_lambdas_indices(k) = CV_min_index;
    [F_not_normalized(k,:),U_normalized(:,k)] = fPCAManifold(X_residuals, R0, R1, loglambdaseq(CV_min_index), niter, index_NA);
    %remove from data matrix PC computed, so we can repply the algorithm to
    %the residuals and get the next PC function
    X_residuals = X_residuals - (U_normalized(:,k) * F_not_normalized(k,:));
end

F_normalized = zeros(size(F_not_normalized));
for k = 1:N_PC
    F_normalized(k,:) = F_not_normalized(k,:)./getL2Norm(F_not_normalized(k,:),R0);
end

%Un-normlized PC vectors (put back variance to each PC vector)
U_not_normalized = zeros(size(U_normalized));
for k = 1:N_PC
    U_not_normalized(:,k) = U_normalized(:,k).*getL2Norm(F_not_normalized(k,:),R0);
end


% Plot PC functions

% Construct matrix where each row is a (normalized) PC function (in this
% case I plot the first 3 PC functions
write_vtk_el(manifold.vertices,manifold.faces,F_normalized(1:5,:), 'PCfunctions.vtk', 'PC')

% Save matrix with scores as a CSV file
csvwrite('PCScores.csv',U_not_normalized)

%% Amount of explained variance by the first N_PC PC functions

[Q,R] = qr(U_not_normalized);
explained_var = diag(R).^2/(size(X_0,1));
trace(U_not_normalized' * U_not_normalized)
% Amount of variance explained by the single PC functions
plot(explained_var,'b--o');

[U,S,V] = svd(X_0,'econ');
U_ALL = zeros(size(U_not_normalized));
for i = 1:size(S,1)
    U_ALL(:,i) = U(:,i)*S(i,i)*getL2Norm(V(:,i),R0);
end
total_var = trace(U_ALL' * U_ALL)/(size(X_0,1));

% Percentage of variance explained by the first N PC functions
plot(cumsum(explained_var)./total_var,'b--o');