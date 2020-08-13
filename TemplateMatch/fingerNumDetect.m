clear
std_template = zeros(784, 10);
% 读入标准数据，建立模板
for i = 0:9
    mat_tmp = imresize(imread(['车牌\',num2str(i),'.bmp']), [28, 28]);
    if length(size((mat_tmp))) == 3
        mat_tmp = mat_tmp(:, :, 1);
    end
    std_template(:, i+1) = reshape(mat_tmp, 784, 1);
end

diff = zeros(1, 10);
seq = 0:9;
for i = 1:100

    mat_tmp = imresize(imread(['手写数字\0\',num2str(i),'.bmp']), [28, 28]);
    if length(size((mat_tmp))) == 3
        mat_tmp = mat_tmp(:, :, 1);
    end
    vector_tmp = double(reshape(mat_tmp, 784, 1));
    for j = 0:9
       diff(j+1) = sum(abs(vector_tmp - std_template(:, j+1)));  
    end
    place(i) = seq*(diff == min(diff))';
    
    if place(i) == 0
        fprintf('%d is checked out\n', i);
    end

end