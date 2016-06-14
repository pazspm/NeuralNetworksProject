mkdir('./Results');
for n = 1:1
    fprintf('Rodando iteração: %d ...', n);
    %Assinatura da função redes neurais, em ordem:
    %num_intermediate_nodes    num de nós na camada intermediária(int)
    %learning_rate             taxa de aprendizagem(doubleO)
    %activation_function_name  função de ativação(string)
    %output_function_name      função dos nós de saída(string)
    %learning_algorithm_name   algoritmo de aprendizagem(string)
    %weigth_algorithm_name)    algoritmo de aprendizegem do pesos(string)
    
    %Opções de função de ativação: 
    %'tansig', 'logsig', or 'purelin'
    
    %Opções de função de nó de saída:
    %'tansig', 'logsig', or 'purelin'
    
    %Opções de algoritmo de aprendizagem:
    %'traincgb', 'traincgf', 'traincgp', 'traingda', 'traingdm', 'traingdx', 'trainlm',
    %'trainoss', 'trainrp', 'trainscg
    
    %Opções de algoritmo de aprendizagem de peso:
    %'learngd' or 'learngdm'
    
    [targets, otuputs, MSE_train, MSE_valid, MSE_test, desempenho, desempenhoTeste]=redes_neurais(50, 0.2, 'tansig', 'tansig', 'traingdm', 'learngdm');
    %Calcula a area embaixo da curva ROC
    [X_0,Y_0,T_0,AUC_0] = perfcurve(targets(1,:), otuputs(1,:), 1);
    [X_1,Y_1,T_1,AUC_1] = perfcurve(targets(2,:), otuputs(2,:), 1);
    %Plota a matriz de confusão
    outdir = sprintf('./Results/Iteration%d', n);
    mkdir(outdir);
    figure('Name', 'Matriz de confusão', 'Visible', 'Off');
    plotconfusion(targets, otuputs);
    print(strcat(outdir, '/Confusion') , '-dpng');
    %Plota a curva ROC
    figure('Name', 'Curva ROC', 'visible', 'off');
    plotroc(targets, otuputs);
    print(strcat(outdir, '/ROC'), '-dpng');
    fileID = fopen(strcat(outdir, '/data.txt'), 'w');
    fprintf(fileID, 'Resultados iteração: %d ... \r\n', n);
    fprintf(fileID, 'MSE para o conjunto de treinamento: %6.5f \r\n',desempenho.perf(length(desempenho.perf)));
    fprintf(fileID, 'MSE para o conjunto de validacao: %6.5f \r\n',desempenho.vperf(length(desempenho.vperf)));
    fprintf(fileID, 'MSE para o conjunto de teste: %6.5f \r\n',desempenhoTeste);
    fprintf(fileID, 'AUC-0: %0.10f\r\nAUC-1: %0.10f \r\n', AUC_0, AUC_1);
    fclose(fileID);
end