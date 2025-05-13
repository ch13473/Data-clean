clc;
clear all;
close all;


%% 数据处理
filename = 'data.xlsx' ;
data = readtable(filename,'Sheet','Sheet1'); % 导入数据

format longg
x11 = data{:,2}'; % dirty data
x30 = data{:,3}; % raw data

%% 方法1：移动窗口3o法 Moving window 3o method
tic;
window_length = 100; % 移动窗口尺寸
window_buchang = 20; % 移动窗口步长
x_ind = [1:window_buchang:length(x11)-window_length+1] + [0:window_length-1]';

X1 = x11;
for j = 1:size(x_ind,2)
    X1(x_ind(:,j)) = layida(X1(x_ind(:,j)));
    x_ind(1,j) / x_ind(1,end)
end
X1(isnan(X1)) = interp1(find(~isnan(X1)), X1(~isnan(X1)), find(isnan(X1)), 'linear'); 
time1 = toc;
%% 方法2：移动中值法 Moving median method
tic;
X2= smoothdata(x11,"movmedian",200);  
time2 = toc;
%% 方法3：MODWT
tic;
levelForReconstruction = [false,false,false,false,false,false,false,true,true,true];
wt = modwt(x11,'sym8',9);
mra = modwtmra(wt,'sym8');
X3 = sum(mra(levelForReconstruction,:),1);
time3 = toc;
%% 方法4：EMD
tic;
levelForReconstruction = [false,false,false,false,false,false,true,true];
[imf,residual,info] = emd(x11, ...
    SiftRelativeTolerance=0.1, ...
    SiftMaxIterations=20, ...
    MaxNumIMF=9, ...
    MaxNumExtrema=3, ...
    MaxEnergyRatio=10, ...
    Interpolation='pchip');
mra = [imf residual].';
X4 = sum(mra(levelForReconstruction,:),1);
time4 = toc;

%% 方法5：DBSCAN
X5 = x11';
% X5_normalized = (X5 - mean(X5)) / std(X5);
% DBSCAN参数设置
tic;
epsilon = 0.7; % 邻域半径
minPts = 30; % 最小邻域点数
clusters = dbscan(X5, epsilon, minPts);
cleanedData = X5;
cleanedData(clusters == -1) = NaN;% 将异常值替换为 NaN
cleanedData = fillmissing(cleanedData, 'linear');% 可视化清洗和插值结果
X5 = cleanedData';
clear cleanedData clusters data epsilon minPts;
time5 = toc;
%% 方法6：KNN
X6 = x11';
tic;
k = 600; % 近邻数设置
threshold_multiplier = 0.002; % 阈值倍数
distance_matrix = pdist2(X6, X6); % 计算距离矩阵
[~, idx] = mink(distance_matrix, k+1, 2); % 获取k近邻距离（排除自身）
knn_distances = zeros(size(X6));
for i = 1:length(X6)
    knn_distances(i) = mean(distance_matrix(i, idx(i,2:k+1))); % 排除自身
end
median_dist = median(knn_distances); % 自适应阈值计算
MAD = 1.4826 * mad(knn_distances,1); % 修正MAD
threshold = median_dist + threshold_multiplier * MAD;
is_outlier = knn_distances > threshold; % 标记异常值

X6(is_outlier)=nan;
X6(isnan(X6)) = interp1(find(~isnan(X6)), X6(~isnan(X6)), find(isnan(X6)), 'linear'); 
X6 = X6';
X6(isnan(X6)) = x30((isnan(X6)));
clear distance_matrix i idx is_outlier k knn_distances MAD median_dist threshold threshold_multiplier;
time6 = toc;

X7 = x11;
time7 = 0;
%% 方法7:  LOF
X8 = x11'; 
tic;
% LOF参数设置
k = 500; % 邻域点数
% 计算LOF值
lofScores = lof(X8, k); % 设置阈值检测异常值
threshold = 1; % LOF阈值，大于该值则认为是异常值
outliersIdx = lofScores > threshold;
cleanedData = X8;
cleanedData(outliersIdx) = NaN; % 将异常值替换为NaN
cleanedData = fillmissing(cleanedData, 'linear');
X8 = cleanedData';
clear lofScores threshold outliersIdx cleanedData;
time8 = toc;
%% 方法8：IForest
X9 = x11';
tic;
[forest, tf, scores] = iforest(X9, ...
    'ContaminationFraction', 0.6, ... % 假设40%的异常数据
    'NumLearners', 500, ...           % 增加基学习器数量
    'NumObservationsPerLearner', 500); 
cleanedData = X9;
cleanedData(tf) = NaN; % 替换异常值为NaN
filledData = fillmissing(cleanedData, 'linear');
X9 = filledData';
clear cleanedData data filledData forest scores tf;
time9 = toc;

