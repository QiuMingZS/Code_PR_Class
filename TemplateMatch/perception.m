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
        label(j) = test_labels1(i);%ȡ��Ӧ��ǩ
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
% �������룺���ݣ�������������ǩ��ѧϰ�ʣ���ֹ�ִ�
% �����ѵ���õ���Ȩֵ����
% ѵ��������������������ѧϰ�ʣ������������˹̶�ֵ
 
function [w]=perceptionLearn(x,y,learningRate,maxEpoch)
    [rows,cols]=size(x);
    x=[x,ones(rows,1)];%����
    w=zeros(1,cols+1);%ͬ��
    for epoch=1:maxEpoch%���ɷ��������������ִ�
        flag=true;%��־λ����ѵ�����
        for sample=1:rows
            if sign(x(sample,:)*w')~=y(sample)%�����Ƿ���ȷ�����������Ȩֵ
                flag=false;
               %����ͽ̰����в�ͬ�������й淶������ô����Ȩֵʱ��Ҫ��ǩ���䵱�ݶȷ���ı���
                w=w+learningRate*y(sample)*x(sample,:);
            end
        end
        if flag==true
            break;
        end
    end
end

% mat2vector.m
% ���룺ͼƬ���ݣ����󣩣���������
% �������ã���ͼƬ��ת��Ϊ����������ϣ�ÿ����������Ϊһ��ͼƬ������
% �����������*ͼƬ����������С�ľ���

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

