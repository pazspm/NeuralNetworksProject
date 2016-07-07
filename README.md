# Neural Networks Project

This repository is destined for Neural Networks [IF701](http://www.cin.ufpe.br/~gcv/web_lci/intro.html "IF701")'s course Project.

It is given a Neural Network script implementation **redes_neurais.m** by the professor Germano C. Vasconcelos. Having this, the main goal is to understand the effects of the different parameters of a Neural Network and focus on achieve its best performance applied to a problem.

We took a dataset of breast cancer detected using mammography, the dataset contains approximately 11183 records, each record has 6 atributes, its classification (10923 to class 0 and 260 to class 1) and it's available in **/Datasets**.

# First step: Choosing datasets

To choose the datasets to be loaded you first have to go to **redes_neurais.m** and look for the line **16** where you can fill the path to your data.

```
%    Opening files
arquivoTreinamento = fopen(fullfile('Datasets', 'smote_learning_data.csv'),'rt');
arquivoValidacao   = fopen(fullfile('Datasets', 'smote_validation_data.csv'),'rt');
arquivoTeste       = fopen(fullfile('Datasets', 'smote_test_data.csv'),'rt');
```
arquivoTreinamento, means the path to the learning training data.
arquivoValidacao, means the path to the validation training data.
arquivoTeste, means the path to the test training data.

See **/Datasets** folder and files to understand the data format.

# Second step: Configuring and Running the Net

The project is based on Matlab so you should have access to this platform in order to run the script.

Some pre-defined parameters for the Net are described in **redes_neurais.m** and are given bellow. Our bests results were achieved with these configurations:

```
rede.trainParam.epochs   = 15000;    % Max number of epochs/iterations
rede.trainParam.lr       = learning_rate;  % Learn rate defined as a parameter of the function
rede.trainParam.goal     = 0;      % Error min to achieve during training
rede.trainParam.max_fail = 20;     % Max quantity of failures during validation
rede.trainParam.min_grad = 0;      % Min gradient criteria
rede.trainParam.show     = 10;     % Number of iterations shown in screen
rede.trainParam.time     = inf;    % Max time in seconds for training

```

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

% Possible values for the activation function of output neurons
learning_algorithm_name = {
'traincgf' % Conjugate gradient backpropagation with Fletcher-Reeves updates
'traincgp' % Conjugate gradient backpropagation with Polak-Ribiére updates
'traingda' % Gradient descent with adaptive learning rate backpropagation
'traingdm' % Gradient descent with momentum backpropagation
'traingdx' % Gradient descent with momentum and adaptive learning rate backpropagation
'trainlm' % Levenberg-Marquardt backpropagation
'trainoss' % One-step secant backpropagation
'trainrp' % Resilient backpropagation
'trainscg' % Scaled conjugate gradient backpropagation
};

```
The output will be available in "Results" folder, this folder contains a folder for each configuration tested, inside the configuration folder you will have the results.txt as well a folder for each iteration graphic results (AUC and Confusion Matrix). The results.txt file contains a compilation of performance of this configuration according with the number of iterations choosen before.

# More scripts
## How to run Adapted SMOTE algorithm

A variation of [SMOTE](https://www.jair.org/media/953/live-953-2037-jair.pdf "SMOTE") algorithm was implemented and it is in the file: **adapted_smote.py**

An example of execution is below:

```
python adapted_smote.py c1_file_data.csv c2_file_data.csv k
```
First argument is the class 1 file name, second argument is the class 2 file name, the last one consists in the number of how many neighbors should be considered in the SMOTE search for the closest neighbors. By default the output file is named as "c2_adapted_smote.csv".

## How to parse the data results #

Because the results are not easy to copy and paste to other softwares, we created a parser that reads all the results given and returns the pure data with tab separating them, one per line. An example below:

```
python3 to_line.py ./vddm/level_1.5/neruons_*/Results.txt -flag > compiled-results.in
```

This example returns all the results generated in level 1.5 and prints them in the file test.in. The **flag** is to indicate not to print the file path. The **flag** should be used if the order of the print it not known.

A sample of the output for the command above is:

```
0.08442	0.01625	0.10686	0.01272	0.08130	0.02087	0.9155609923	0.0200833200	0.9152082385	0.0208089504
0.11256	0.09452	0.12655	0.09331	0.09947	0.08099	0.9102270141	0.0668725209	0.8561606736	0.2135800336
0.12732	0.11002	0.14880	0.09855	0.11481	0.07513	0.9145180929	0.0348379640	0.8383744879	0.2476504636
```
