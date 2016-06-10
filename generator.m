mkdir('./Results');
for n = 1:1
    fprintf('Rodando iteração: %d ...', n);
    [targets, otuputs, MSE_train, MSE_valid, MSE_test]= redes_neurais();
    %Calcula a area embaixo da curva ROC
    [X_0,Y_0,T_0,AUC_0] = perfcurve(saidasTeste(1,:), saidasRedeTeste(1,:), 1);
    [X_1,Y_1,T_1,AUC_1] = perfcurve(saidasTeste(2,:), saidasRedeTeste(2,:), 1);
    %Plota a matriz de confusão
    outdir = sprintf('./Results/Iteration%d', n);
    mkdir(outdir);
    figure('Name', 'Matriz de confusão', 'Visible', 'Off');
    plotconfusion(saidasTeste, saidasRedeTeste);
    print(strcat(outdir, '/Confusion') , '-dpng');
    %Plota a curva ROC
    figure('Name', 'Curva ROC', 'visible', 'off');
    plotroc(saidasTeste, saidasRedeTeste);
    print(strcat(outdir, '/ROC'), '-dpng');
    fileID = fopen(strcat(outdir, '/data.txt'), 'w');
    fprintf(fileID, 'Resultados iteração: %d ... \r\n', n);
    fprintf(fileID, 'MSE para o conjunto de treinamento: %6.5f \r\n',desempenho.perf(length(desempenho.perf)));
    fprintf(fileID, 'MSE para o conjunto de validacao: %6.5f \r\n',desempenho.vperf(length(desempenho.vperf)));
    fprintf(fileID, 'MSE para o conjunto de teste: %6.5f \r\n',desempenhoTeste);
    fprintf(fileID, 'AUC-0: %0.10f \r\nAUC-1: %0.10f \r\n', AUC_0, AUC_1);
    fclose(fileID);
end