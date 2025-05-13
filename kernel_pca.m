% 核 PCA 函数
function [eigenvalues, score] = kernel_pca(X, kernel_type, kernel_scale)
    % 计算核矩阵
    K = compute_kernel_matrix(X, kernel_type, kernel_scale); % 核矩阵
    N = size(K, 1);
    
    % 中心化核矩阵
    K_centered = K - mean(K, 1) - mean(K, 2) + mean(K(:));
    
    % 计算特征值和特征向量
    [eigenvectors, eigenvalues] = eig(K_centered);
    eigenvalues = diag(eigenvalues);
    [eigenvalues, idx] = sort(eigenvalues, 'descend'); % 按特征值排序
    eigenvectors = eigenvectors(:, idx);
    
    % 计算得分
    score = K_centered * eigenvectors;
end