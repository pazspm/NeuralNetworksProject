LEARNING_FILE = 'learning_data_c2.csv';
VALIDATION_FILE = 'validation_data_c2.csv';
TEST_FILE = 'test_data_c2.csv';
class_data = csvread('c2_data.csv');
qtd_ele = size(class_data,1);

learning_size = floor(0.50*qtd_ele);
validation_size = floor(0.25*qtd_ele);
test_size = qtd_ele - learning_size - validation_size;

t1 = fopen(LEARNING_FILE, 'w');
t2 = fopen(VALIDATION_FILE, 'w');
t2 = fopen(TEST_FILE, 'w');

ar = [1, 2, 3];

for i = 1:qtd_ele
    num = ar(randi(numel(ar)));
    if num == 1
        dlmwrite(LEARNING_FILE, class_data(i,:), '-append');
        learning_size = learning_size - 1;
    elseif num == 2
        dlmwrite(VALIDATION_FILE, class_data(i,:), '-append');
        validation_size = validation_size - 1;
    else
        dlmwrite(TEST_FILE, class_data(i,:), '-append');
        test_size = test_size - 1;
    end
  
    if learning_size <= 0
        ar(ar == 1) = [];
    end
    if validation_size <= 0
        ar(ar == 2) = [];
    end
    if test_size <= 0
        ar(ar == 3) = [];
    end
end