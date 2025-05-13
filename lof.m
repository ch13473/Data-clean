function lofScores = lof(data, k)
    n = length(data);
    lrd = zeros(n, 1); % 局部可达密度
    lofScores = zeros(n, 1); % LOF分数
    
    % 计算每个点的局部可达密度
    for i = 1:n
        % 找到k个最近邻
        distances = abs(data - data(i));
        [~, idx] = sort(distances);
        neighbors = idx(2:k+1); % 不包括自己
        
        % 计算可达距离
        reachDist = max(distances(neighbors), distances(neighbors));
        % 计算局部可达密度
        lrd(i) = 1 / (mean(reachDist) + eps); % eps防止除零
    end
    
    % 计算LOF分数
    for i = 1:n
        % 找到k个最近邻
        distances = abs(data - data(i));
        [~, idx] = sort(distances);
        neighbors = idx(2:k+1); % 不包括自己
        
        % 计算LOF
        lofScores(i) = mean(lrd(neighbors)) / (lrd(i) + eps);
    end
end