mkdir('./Results');

% Escolher aqui n�mero de itera��es por experimento
number_iterations = 2;

% Escolher os valores dos diferentes experimentos, atualmente apenas para o
% n�mero de n�s
%number_neurons_input = [1,3,5,12,27];
number_neurons_input= [3];
length_vector_number = size(number_neurons_input,2);

%learning_rate = [0.05,0.1,0.2,0.3,0.7,1.1];
learning_rate = [0.2];
length_vector_learning = size(learning_rate,2);

%activation_function_name = {'tansig' 'logsig' 'purelin'};
activation_function_name = {'tansig'};
length_vector_act = size(activation_function_name,2);

%output_function_name = {'tansig' 'logsig' 'purelin'};
output_function_name = {'tansig'};
length_vector_out = size(output_function_name,2);

for y = 1:length_vector_out
    for k = 1:length_vector_act
        for j = 1:length_vector_learning
            for i = 1:length_vector_number
                outdir = sprintf('./Results/neruons_%d_learn_%g_act_', number_neurons_input(1,i),learning_rate(1,j));
                outdir = strcat(outdir,activation_function_name(1,k));
                outdir = strcat(outdir,'_out_');
                outdir = strcat(outdir,output_function_name(1,y));
                s = outdir{1};
                mkdir(s);

                trainMseVector = [];
                validMseVector = [];
                testMseVector = [];

                auc0Vector = [];
                auc1Vector = [];

                for n = 1:number_iterations
                    fprintf('Rodando itera�ao: %d ...', n);

                    %Assinatura da fun�ao redes neurais, em ordem:
                    %num_intermediate_nodes    num de n�s na camada intermedi�ria(int)
                    %learning_rate             taxa de aprendizagem(doubleO)
                    %activation_function_name  fun�ao de ativa�ao(string)
                    %output_function_name      fun�ao dos n�s de sa�da(string)
                    %learning_algorithm_name   algoritmo de aprendizagem(string)
                    %weigth_algorithm_name)    algoritmo de aprendizegem do pesos(string)

                    %Op��es de fun�ao de ativa�ao: 
                    %'tansig', 'logsig', or 'purelin'

                    %Op��es de fun�ao de n� de sa�da:
                    %'tansig', 'logsig', or 'purelin'

                    %Op��es de algoritmo de aprendizagem:
                    %'traincgb', 'traincgf', 'traincgp', 'traingda', 'traingdm', 'traingdx', 'trainlm',
                    %'trainoss', 'trainrp', 'trainscg

                    %Op��es de algoritmo de aprendizagem de peso:
                    %'learngd' or 'learngdm'
                    
                    neurons = number_neurons_input(1,i);
                    learn = learning_rate(1,j);
                    act = activation_function_name(1,k);                    
                    out = output_function_name(1,y);                 
                    [targets, otuputs, MSE_train, MSE_valid, MSE_test]=redes_neurais(neurons, learn, act{1}, out{1}, 'traingdm', 'learngdm');

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
                    figure('Name', 'Matriz de confusao', 'Visible', 'Off');
                    plotconfusion(targets, otuputs);
                    print(strcat(outdir2{1}, '/Confusion') , '-dpng');

                    %Plota a curva ROC
                    figure('Name', 'Curva ROC', 'visible', 'off');
                    plotroc(targets, otuputs);
                    print(strcat(outdir2{1}, '/ROC'), '-dpng');
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