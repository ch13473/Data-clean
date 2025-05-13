function in = layida(data)
% in为正常值，out为离群值

in = data; 
% out = nan(length(data),1); %定义输入和输出

di = 2*in(2:end-1)-(in(3:end)+in(1:end-2));

average = mean(di,'omitnan');  % x中所有元素的均值
standard = std(di,'omitnan');  % x的标准差

tmp = abs(di-average) > standard*3; % 判断离群点
ind = find(tmp);
ind = ind + 1;
in(ind) = nan; %离群点赋值为空

end