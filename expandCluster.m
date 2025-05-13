% 扩展聚类
function expandCluster(data, neighbors, clusterId, epsilon, minPts, visited, idx)
    idx(neighbors) = clusterId; % 分配聚类编号
    i = 1;
    while i <= length(neighbors)
        j = neighbors(i);
        if ~visited(j)
            visited(j) = true; % 标记为已访问
           newNeighbors = regionQuery(data, j, epsilon); % 查找邻域点
            if length(newNeighbors) >= minPts
                neighbors = [neighbors; newNeighbors]; % 扩展邻域
            end
        end
        if idx(j) == 0 || idx(j) == -1
            idx(j) = clusterId; % 分配聚类编号
        end
        i = i + 1;
    end
end