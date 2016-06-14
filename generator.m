mkdir('./Results');

number_iterations = 2;

trainMseVector = [];
validMseVector = [];
testMseVector = [];

auc0Vector = [];
auc1Vector = [];

for n = 1:number_iterations
    fprintf('Rodando iteração: %d ...', n);
    [targets, otuputs, MSE_train, MSE_valid, MSE_test]= redes_neurais();
    
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
    outdir = sprintf('./Results/Iteration%d', n);
    mkdir(outdir);
    
    %Plota a matriz de confusão
    figure('Name', 'Matriz de confusão', 'Visible', 'Off');
    plotconfusion(targets, otuputs);
    print(strcat(outdir, '/Confusion') , '-dpng');
    
    %Plota a curva ROC
    figure('Name', 'Curva ROC', 'visible', 'off');
    plotroc(targets, otuputs);
    print(strcat(outdir, '/ROC'), '-dpng');
    
end

meanTrainMse = mean(trainMseVector);
meanValidMse = mean(validMseVector);
meanTestMse = mean(testMseVector);
meanAuc0 = mean(auc0Vector);
meanAuc1 = mean(auc1Vector);

rootdir = './Results';
fileID = fopen(strcat(rootdir, '/results.txt'), 'w');
fprintf(fileID, 'Resultados médio de %d iterações... \r\n\r\n', n);

str = mat2str(trainMseVector);
fprintf(fileID, '%s\r\n' ,str);
fprintf(fileID, 'MSE para o conjunto de treinamento: %6.5f \r\n\r\n',meanTrainMse);

str = mat2str(validMseVector);
fprintf(fileID, '%s\r\n' ,str);
fprintf(fileID, 'MSE para o conjunto de validacao: %6.5f \r\n\r\n',meanValidMse);

str = mat2str(testMseVector);
fprintf(fileID, '%s\r\n' ,str);
fprintf(fileID, 'MSE para o conjunto de teste: %6.5f \r\n\r\n',meanTestMse);

str = mat2str(auc0Vector);
fprintf(fileID, '%s\r\n' ,str);
str = mat2str(auc1Vector);
fprintf(fileID, '%s\r\n' ,str);

fprintf(fileID, 'AUC-0: %0.10f\r\nAUC-1: %0.10f \r\n', meanAuc0, meanAuc1);
fclose(fileID);

