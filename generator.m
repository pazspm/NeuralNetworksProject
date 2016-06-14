mkdir('./Results');
for n = 1:1
    fprintf('Rodando itera��o: %d ...', n);
    %Assinatura da fun��o redes neurais, em ordem:
    %num_intermediate_nodes    num de n�s na camada intermedi�ria(int)
    %learning_rate             taxa de aprendizagem(doubleO)
    %activation_function_name  fun��o de ativa��o(string)
    %output_function_name      fun��o dos n�s de sa�da(string)
    %learning_algorithm_name   algoritmo de aprendizagem(string)
    %weigth_algorithm_name)    algoritmo de aprendizegem do pesos(string)
    
    %Op��es de fun��o de ativa��o: 
    %'tansig', 'logsig', or 'purelin'
    
    %Op��es de fun��o de n� de sa�da:
    %'tansig', 'logsig', or 'purelin'
    
    %Op��es de algoritmo de aprendizagem:
    %'traincgb', 'traincgf', 'traincgp', 'traingda', 'traingdm', 'traingdx', 'trainlm',
    %'trainoss', 'trainrp', 'trainscg
    
    %Op��es de algoritmo de aprendizagem de peso:
    %'learngd' or 'learngdm'
    
    [targets, otuputs, MSE_train, MSE_valid, MSE_test, desempenho, desempenhoTeste]=redes_neurais(50, 0.2, 'tansig', 'tansig', 'traingdm', 'learngdm');
    %Calcula a area embaixo da curva ROC
    [X_0,Y_0,T_0,AUC_0] = perfcurve(targets(1,:), otuputs(1,:), 1);
    [X_1,Y_1,T_1,AUC_1] = perfcurve(targets(2,:), otuputs(2,:), 1);
    %Plota a matriz de confus�o
    outdir = sprintf('./Results/Iteration%d', n);
    mkdir(outdir);
    figure('Name', 'Matriz de confus�o', 'Visible', 'Off');
    plotconfusion(targets, otuputs);
    print(strcat(outdir, '/Confusion') , '-dpng');
    %Plota a curva ROC
    figure('Name', 'Curva ROC', 'visible', 'off');
    plotroc(targets, otuputs);
    print(strcat(outdir, '/ROC'), '-dpng');
    fileID = fopen(strcat(outdir, '/data.txt'), 'w');
    fprintf(fileID, 'Resultados itera��o: %d ... \r\n', n);
    fprintf(fileID, 'MSE para o conjunto de treinamento: %6.5f \r\n',desempenho.perf(length(desempenho.perf)));
    fprintf(fileID, 'MSE para o conjunto de validacao: %6.5f \r\n',desempenho.vperf(length(desempenho.vperf)));
    fprintf(fileID, 'MSE para o conjunto de teste: %6.5f \r\n',desempenhoTeste);
    fprintf(fileID, 'AUC-0: %0.10f\r\nAUC-1: %0.10f \r\n', AUC_0, AUC_1);
    fclose(fileID);
end