% possivel http://stackoverflow.com/questions/5444248/random-order-of-rows-matlab

class1_File = './Datasets/OriginalDatabase/smote_validation_data_c1.csv';
class2_File = './Datasets/OriginalDatabase/smote_validation_data_c2.csv';
merge_file = './Datasets/OriginalDatabase/smote_validation_data.csv';

merge_file_id = fopen(merge_file, 'w') 

class_data1 = csvread(class1_File);
class_data2 = csvread(class2_File);

class_data1_size = size(class_data1, 1);
class_data2_size = size(class_data2, 1);

for i = 1: class_data2_size
    class_data1 = [class_data1;class_data2(i,:)];
end

class_data1 = class_data1(randperm(class_data1_size + class_data2_size),:);

dlmwrite(merge_file, class_data1)
