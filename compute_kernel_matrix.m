% 核矩阵计算函数
function K = compute_kernel_matrix(X, kernel_type, kernel_scale)
    N = size(X, 1);
    K = zeros(N, N);
    for i = 1:N
        for j = 1:N
            if strcmp(kernel_type, 'gaussian')
                K(i, j) = exp(-norm(X(i, :) - X(j, :))^2 / (2 * kernel_scale^2)); % 高斯核
            elseif strcmp(kernel_type, 'polynomial')
                K(i, j) = (X(i, :) * X(j, :)' + 1)^kernel_scale; % 多项式核
            end
        end
    end
end