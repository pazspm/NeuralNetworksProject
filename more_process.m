% apply in each category: learning, validation and test
class1_File = 'learning_data_c1.csv';
class2_File = 'learning_data_c2.csv';

class_data1 = csvread(class1_File);
class_data2 = csvread(class2_File);

val1 = size(class_data1, 1);
val2 = size(class_data2, 1);
dif = val1 - val2;
val1
disp(dif);
while dif > 0
    %escolhe randomicamente alguém em classe2 e copia para classe2 novamente
    rand_sample = class_data2(randi(numel(1:val2)),:);
    dlmwrite(class2_File, rand_sample, '-append');
    dif = dif - 1
end