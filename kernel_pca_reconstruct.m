% 核 PCA 重建函数
function X_reconstructed = kernel_pca_reconstruct(score, X, kernel_type, kernel_scale)
    N = size(X, 1);
    K = compute_kernel_matrix(X, kernel_type, kernel_scale); % 核矩阵
    K_centered = K - mean(K, 1) - mean(K, 2) + mean(K(:));
    X_reconstructed = K_centered * pinv(score'); % 重建数据
end