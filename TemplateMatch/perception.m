% a perception for figure recognization
% creator: Guanzheng Wang
% time: 2020.03.03.11.55

%% prepare
clc, clear variables

%% load data
load('mnist\test_images.mat');
load('mnist\test_labels.mat');
%% set training times
train_num = 1000;
test_num = 200;
%% temp var and parameters of the perception
j = 1;
lr = 0.01;      % learning rate
epoch = 10;     % training 10 big times
number = [8, 4];% the number to take out
%% to take out the picture of number set upper
for i = 1:10000
    if test_labels1(i)==number(1)|| test_labels1(i)==number(2)
        data(:,:,j) = test_images(:,:,i);
        label(j) = test_labels1(i);%取相应标签
        j=j+1;
     if j>train_num+test_num
         break;
     end
    end
end
%% change the label to be -1 and 1
for k = 1:train_num+test_num
    if label(k)==number(1)
        label(k)=-1;
    end
    if label(k)==number(2)
        label(k)=1;
    end
end

data_ = mat2vector(data,train_num+test_num);
test_data = [data_(train_num+1:train_num+test_num,:),ones(test_num,1)];

%% training 
w=perceptionLearn(data_(1:train_num,:),label(1:train_num),lr,epoch);
%% test
for k = 1:test_num
    if test_data(k,:)*w'>0
        result(k) = 1;
    else
        result(k) = -1;
    end
end
%% ouput the accuracy
acc = 0.;
for sample = 1:test_num
    if result(sample)==label(train_num+sample)
        acc = acc+1;
    end
end
fprintf('The accuracy is: %5.2f%%\n',(acc/test_num)*100);
 
%perceptionLearn.m
% 函数输入：数据（行向量），标签，学习率，终止轮次
% 输出：训练得到的权值向量
% 训练方法：单样本修正，学习率（步长）采用了固定值
 
function [w]=perceptionLearn(x,y,learningRate,maxEpoch)
    [rows,cols]=size(x);
    x=[x,ones(rows,1)];%增广
    w=zeros(1,cols+1);%同上
    for epoch=1:maxEpoch%不可分情况下整体迭代轮次
        flag=true;%标志位真则训练完毕
        for sample=1:rows
            if sign(x(sample,:)*w')~=y(sample)%分类是否正确？错误则更新权值
                flag=false;
               %这里和教案稍有不同，不进行规范化，那么更新权值时需要标签来充当梯度方向的变量
                w=w+learningRate*y(sample)*x(sample,:);
            end
        end
        if flag==true
            break;
        end
    end
end

% mat2vector.m
% 输入：图片数据（矩阵），样本个数
% 函数作用：将图片组转化为行向量的组合，每个行向量作为一张图片的特征
% 输出：样本数*图片像素数量大小的矩阵

function [data_]= mat2vector(data,num)
    [row,col,~] = size(data);
    data_ = zeros(num,row*col);
    for page = 1:num
        for rows = 1:row
            for cols = 1:col
                data_(page,((rows-1)*col+cols)) = im2double(data(rows,cols,page));
            end
        end
    end
end

