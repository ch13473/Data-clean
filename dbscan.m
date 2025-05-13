% DBSCAN函数实现
function idx = dbscan(data, epsilon, minPts)
    n = length(data);
    idx = zeros(n, 1); % 初始化聚类标签
    clusterId = 0; % 聚类编号
    visited = false(n, 1); % 记录是否已访问
    
    for i = 1:n
        if ~visited(i)
            visited(i) = true; % 标记为已访问
           neighbors = regionQuery(data, i, epsilon); % 查找邻域点
            if length(neighbors) < minPts
                idx(i) = -1; % 标记为噪声点
            else
                clusterId = clusterId + 1; % 新聚类编号
                expandCluster(data, neighbors, clusterId, epsilon, minPts, visited, idx);
            end
        end
    end
end