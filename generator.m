mkdir('./Results');

% Number of iteration over each experiment
number_iterations = 10;

% Possible values for the number of hidden neurons
% nivel 1: number_neurons_input = [1,3,5,12,27];
number_neurons_input= [12];
length_vector_number = size(number_neurons_input,2);

% Possible values for the learning rate
% nivel 1,5: learning_rate = [0.05,0.1,0.2,0.3,0.7,1.1];
learning_rate = [0.05];
length_vector_learning = size(learning_rate,2);

% Possible values for the activation function of intermediate hidden neurons
% nivel 2: activation_function_name = {'tansig' 'logsig'};
activation_function_name = {'tansig'};
length_vector_act = size(activation_function_name,2);

% Possible values for the activation function of output neurons
% nivel 2: output_function_name = {'logsig' 'purelin'};
output_function_name = {'logsig'};
length_vector_out = size(output_function_name,2);

% Possible values for the activation function of output neurons
%learning_algorithm_name = {'traincgb', 'traincgf', 'traincgp', 'traingda', 'traingdm', 'traingdx', 'trainlm','trainoss', 'trainrp', 'trainscg'};
learning_algorithm_name = {'traincgf', 'traincgp', 'traingda', 'traingdm', 'traingdx', 'trainlm','trainoss', 'trainrp', 'trainscg'};
length_vector_algo = size(learning_algorithm_name,2);

for z = 1:length_vector_algo
    for y = 1:length_vector_out
        for k = 1:length_vector_act
            for j = 1:length_vector_learning
                for i = 1:length_vector_number
                    outdir = sprintf('./Results/neruons_%d_learn_%g_act_', number_neurons_input(1,i),learning_rate(1,j));
                    outdir = strcat(outdir,activation_function_name(1,k));
                    outdir = strcat(outdir,'_out_');
                    outdir = strcat(outdir,output_function_name(1,y));
                    outdir = strcat(outdir,'_algo_');
                    outdir = strcat(outdir,learning_algorithm_name(1,z));
                    s = outdir{1};
                    mkdir(s);

                    trainMseVector = [];
                    validMseVector = [];
                    testMseVector = [];

                    auc0Vector = [];
                    auc1Vector = [];

                    for n = 1:number_iterations
                        fprintf('Rodando iteraçao: %d ...', n);

                        %Assinatura da funçao redes neurais, em ordem:
                        %num_intermediate_nodes    num de nós na camada intermediária(int)
                        %learning_rate             taxa de aprendizagem(doubleO)
                        %activation_function_name  funçao de ativaçao(string)
                        %output_function_name      funçao dos nós de saída(string)
                        %learning_algorithm_name   algoritmo de aprendizagem(string)
                        %weigth_algorithm_name)    algoritmo de aprendizegem do pesos(string)

                        %Opções de funçao de ativaçao: 
                        %'tansig', 'logsig', or 'purelin'

                        %Opções de funçao de nó de saída:
                        %'tansig', 'logsig', or 'purelin'

                        %Opções de algoritmo de aprendizagem:
                        %'traincgb', 'traincgf', 'traincgp', 'traingda', 'traingdm', 'traingdx', 'trainlm',
                        %'trainoss', 'trainrp', 'trainscg

                        %Opções de algoritmo de aprendizagem de peso:
                        %'learngd' or 'learngdm'

                        neurons = number_neurons_input(1,i);
                        learn = learning_rate(1,j);
                        act = activation_function_name(1,k);                    
                        out = output_function_name(1,y);  
                        algo = learning_algorithm_name(1,z);
                        [targets, otuputs, MSE_train, MSE_valid, MSE_test]=redes_neurais(neurons, learn, act{1}, out{1}, algo{1}, 'learngdm');

                        %Adicionando os valores do MSE
                        trainMseVector(end+1) = MSE_train;
                        validMseVector(end+1) = MSE_valid;
                        testMseVector(end+1) = MSE_test;
                        %Calcula a area embaixo da curva ROC
                        [X_0,Y_0,T_0,AUC_0] = perfcurve(targets(1,:), otuputs(1,:), 1);
                        [X_1,Y_1,T_1,AUC_1] = perfcurve(targets(2,:), otuputs(2,:), 1);

                        %Adicionando os valores do AUC
                        auc0Vector(end+1) = AUC_0;
                        auc1Vector(end+1) = AUC_1;

                        %Criando diretorio de resultados
                        iteration = sprintf('/Iteration%d',n);
                        outdir2 = strcat(outdir,iteration);
                        mkdir(outdir2{1});

                        %Plota a matriz de confusao
                        a = figure('Name', 'Matriz de confusao', 'Visible', 'Off');
                        plotconfusion(targets, otuputs);
                        print(strcat(outdir2{1}, '/Confusion') , '-dpng');
                        
                        %Plota a curva ROC
                        b = figure('Name', 'Curva ROC', 'visible', 'off');
                        plotroc(targets, otuputs);
                        print(strcat(outdir2{1}, '/ROC'), '-dpng');
                        
                        delete(a);
                        delete(b);
                        
                    end

                    meanTrainMse = mean(trainMseVector);
                    meanValidMse = mean(validMseVector);
                    meanTestMse = mean(testMseVector);
                    meanAuc0 = mean(auc0Vector);
                    meanAuc1 = mean(auc1Vector);

                    fileID = fopen(strcat(outdir{1}, '/results.txt'), 'w');
                    fprintf(fileID, 'Resultados medio de %d iteracoes... \r\n\r\n', n);

                    str = mat2str(trainMseVector);
                    fprintf(fileID, '%s\r\n' ,str);
                    fprintf(fileID, 'MSE medio para o conjunto de treinamento: %6.5f \r\n',meanTrainMse);
                    fprintf(fileID, 'MSE (desvio padrao) para o conjunto de treinamento: %6.5f \r\n\r\n',std(trainMseVector));

                    str = mat2str(validMseVector);
                    fprintf(fileID, '%s\r\n' ,str);
                    fprintf(fileID, 'MSE medio para o conjunto de validacao: %6.5f \r\n',meanValidMse);
                    fprintf(fileID, 'MSE (desvio padrao) para o conjunto de validacao: %6.5f \r\n\r\n',std(validMseVector));

                    str = mat2str(testMseVector);
                    fprintf(fileID, '%s\r\n' ,str);
                    fprintf(fileID, 'MSE medio para o conjunto de teste: %6.5f \r\n',meanTestMse);
                    fprintf(fileID, 'MSE (desvio padrao) para o conjunto de teste: %6.5f \r\n\r\n',std(testMseVector));

                    str = mat2str(auc0Vector);
                    fprintf(fileID, 'AUCs-0: %s\r\n' ,str);
                    str = mat2str(auc1Vector);
                    fprintf(fileID, 'AUCs-1: %s\r\n' ,str);

                    fprintf(fileID, 'Media de AUC das classes:\r\nAUC-0: %0.10f\r\nAUC-1: %0.10f \r\n', meanAuc0, meanAuc1);
                    fprintf(fileID, 'Desvio padrao de AUC das classes:\r\nAUC-0: %0.10f\r\nAUC-1: %0.10f \r\n', std(auc0Vector), std(auc1Vector));
                    fclose(fileID);
                    
                end
            end
        end
    end
end