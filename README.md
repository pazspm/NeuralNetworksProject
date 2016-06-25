# Neural Networks Project

This repository is destined for Neural Networks [IF701](http://www.cin.ufpe.br/~gcv/web_lci/intro.html "IF701")'s course Project.

It is given a Neural Network script implementation **redes_neurais.m** by the professor Germano C. Vasconcelos. Having this, the main goal is to understand the effects of the different parameters of a Neural Network and focus on achieve its best performance applied to a problem.

We took a dataset of breast cancer detected using mammography, the dataset contains approximately 10000 records, each record has 6 atributes, its classification (0 or 1) and it's available in **/Datasets**.

# Running

The project is based on Matlab so you should have access to this plataform in order to run the script.
To run the script you only have to access the **generator.m** file. This file setup all the experiments, you will also notice that you are allowed to change the parameters as well as you want.

```
% Number of iteration over each experiment
number_iterations = 2;

% Possible values for the number of hidden neurons
number_neurons_input = [1,3,5,12,27];

% Possible values for the learning rate
learning_rate = [0.05,0.1,0.2,0.3,0.7,1.1];

% Possible values for the activation function of intermediate hidden neurons
activation_function_name = {'tansig' 'logsig' 'purelin'};

% Possible values for the activation function of output neurons
output_function_name = {'tansig' 'logsig' 'purelin'};
```

Changing others parameters will be available soon...