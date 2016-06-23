mkdir('./Results');

% Escolher aqui número de iterações por experimento
number_iterations = 1;

% Escolher os valores dos diferentes experimentos, atualmente apenas para o
% número de nós
number_neurons_input = [1,3];
length_vector = size(number_neurons_input,2);

for i = 1:length_vector

    outdir = sprintf('./Results/number_neurons_%d', i);
    mkdir(outdir);
    
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

        [targets, otuputs, MSE_train, MSE_valid, MSE_test]=redes_neurais(number_neurons_input(1,i), 0.2, 'tansig', 'tansig', 'traingdm', 'learngdm');

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
        outdir2 = sprintf('./Results/number_neurons_%d/Iteration%d',i,n);
        mkdir(outdir2);

        %Plota a matriz de confusao
        figure('Name', 'Matriz de confusao', 'Visible', 'Off');
        plotconfusion(targets, otuputs);
        print(strcat(outdir2, '/Confusion') , '-dpng');

        %Plota a curva ROC
        figure('Name', 'Curva ROC', 'visible', 'off');
        plotroc(targets, otuputs);
        print(strcat(outdir2, '/ROC'), '-dpng');

    end

    meanTrainMse = mean(trainMseVector);
    meanValidMse = mean(validMseVector);
    meanTestMse = mean(testMseVector);
    meanAuc0 = mean(auc0Vector);
    meanAuc1 = mean(auc1Vector);

    fileID = fopen(strcat(outdir, '/results.txt'), 'w');
    fprintf(fileID, 'Resultados medio de %d iterações... \r\n\r\n', n);

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