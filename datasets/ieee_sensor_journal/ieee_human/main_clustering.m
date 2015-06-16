% clusterig tesst

clear; close all; clc;

input_files = {'data-fall-backward.txt', 'data-fall-forward.txt', ...
               'data-fall-left.txt', 'data-fall-right.txt', ...
               'data-marching.txt', 'data-rotate-ccw.txt', ...
               'data-rotate-cw.txt', ...
               'data-walk-backward.txt', 'data-walk-forward.txt', ...
               'data-walk-left.txt', 'data-walk-right.txt'};
           
for f =  2 : 2%length(input_files)           
    train_X = load(input_files{f});
    
    [mo, no] = size(train_X)

    train_X =train_X(150:end,1:6);
    
    [mp, np] = size(train_X);
    
    [mo - mp]
    
    
    [m, n] = size(train_X);
    
    kmean_train_X = train_X;
    kmean_train_mean = mean(kmean_train_X);
    kmean_train_X = bsxfun(@minus, kmean_train_X, kmean_train_mean);
    kmean_train_std = std(kmean_train_X);
    kmean_train_X = bsxfun(@rdivide, kmean_train_X, kmean_train_std);
    
    %plot(kmean_train_X);
    
    numClusters = 3;
    
    [train_labels, C] = kmeans(kmean_train_X, numClusters);
    
    C_norm = zeros(numClusters, 6);
    for i = 1 : numClusters
       C_norm(i,:) = C(i,:) / norm(C(i,:), 2); 
    end
    
    hold on;
    plot(kmean_train_X);
    plot(5 * train_labels, 'x');
    hold off;
    % angels
    acosd([C_norm(1,:) * C_norm(2,:)';
    %C_norm(2,:) * C_norm(3,:)';
    %C_norm(3,:) * C_norm(1,:)'
    ])

%{
    cluster_1_data = kmean_train_X(train_labels==1,:);
    cluster_2_data = kmean_train_X(train_labels==2,:);
    
    size(cluster_1_data)
    size(cluster_2_data)
    
    
    if 0,
        c1_angle = [];
        c2_angle = [];

        for i = 1 : size(cluster_1_data, 1)
            x = cluster_1_data(i,:) / norm(cluster_1_data(i,:), 2);
            c1_angle = [c1_angle; acosd(C_norm(1,:) * x')];

        end

        for i = 1 : size(cluster_2_data, 1)
            x = cluster_2_data(i,:) / norm(cluster_2_data(i,:), 2);
            c2_angle = [c2_angle; acosd(C_norm(2,:) * x')];

        end

        figure;
        hold on;
        plot(c1_angle, 'x');
        plot(c2_angle, 'o');
        hold off;
    end
    
    c2_to_c1 = C(2,:) * C_norm(1,:)'
    
    vec = C_norm(1,:) * c2_to_c1;
    
    vec2 = C(2,:) - vec;
    
    len_vec2 = norm(vec2, 2);
    
    
    
    first_one = [c2_to_c1, len_vec2]
    other_one = [abs(C_norm(1,1)), 0]
    
    figure;
    hold on;
    plot(first_one(1), first_one(2), 'x', 'MarkerSize', 5);
    plot(other_one(1), other_one(2), 'o', 'MarkerSize', 5);
    hold off;
    
  %}  
    
    if 0, 
        % Parameters
        no_dims = 2;
        initial_dims = n;
        perplexity = 30;
        theta = 0.5;


        %Run tSNE
        mappedX = fast_tsne(train_X, no_dims, initial_dims, perplexity, theta);

        figure;
        % Plot results
        gscatter(mappedX(:,1),mappedX(:,2), train_labels);
    end
end