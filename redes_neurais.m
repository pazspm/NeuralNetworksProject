
function [targets, outputs, MSE_train, MSE_valid, MSE_test]=redes_neurais(num_intermediate_nodes, learning_rate, activation_function_name, output_function_name, learning_algorithm_name, weigth_algorithm_name)
    echo on
    %    Net information and data
    numEntradas   = 6;     % Number of input neurons
    numEscondidos = num_intermediate_nodes;     % Number of hidden neurons
    numSaidas     = 2;     % Number of output neurons
    numTr         = 10922;   % Number of patterns in training
    numVal        = 5460;    % Number of patterns in validation
    numTeste      = 2769;    % Number of patterns in test

    echo off

    %    Opening files
    % fullfile('Datasets', 'learning_data.csv')
    arquivoTreinamento = fopen(fullfile('Datasets', 'smote_learning_data.csv'),'rt');
    arquivoValidacao   = fopen(fullfile('Datasets', 'smote_validation_data.csv'),'rt');
    arquivoTeste       = fopen(fullfile('Datasets', 'smote_test_data.csv'),'rt');

    %    Reading files and puting on their matrices
    dadosTreinamento    = fscanf(arquivoTreinamento,'%f,',[(numEntradas + numSaidas), numTr]);   % Lendo arquivo de treinamento
    entradasTreinamento = dadosTreinamento(1:numEntradas, 1:numTr);
    saidasTreinamento   = dadosTreinamento((numEntradas + 1):(numEntradas + numSaidas), 1:numTr);

    dadosValidacao      = fscanf(arquivoValidacao,'%f,',[(numEntradas + numSaidas), numVal]);    % Mesmo processo para validacao
    entradasValidacao   = dadosValidacao(1:numEntradas, 1:numVal);
    saidasValidacao     = dadosValidacao((numEntradas + 1):(numEntradas + numSaidas), 1:numVal);

    dadosTeste          = fscanf(arquivoTeste,'%f,',[(numEntradas + numSaidas), numTeste]);      % Mesmo processo para teste
    entradasTeste       = dadosTeste(1:numEntradas, 1:numTeste);
    saidasTeste         = dadosTeste((numEntradas + 1):(numEntradas + numSaidas), 1:numTeste);

    %    Closing files
    fclose(arquivoTreinamento);
    fclose(arquivoValidacao);
    fclose(arquivoTeste);

    % Initialization of the net (to help, type 'help newff')

    for entrada = 1 : numEntradas;  % Creates 'matrizFaixa', which has 'numEntradas' lines, each one equal to [0 1].
         matrizFaixa(entrada,:) = [0 1];
    end

    rede = newff(matrizFaixa,[numEscondidos, numSaidas],{activation_function_name, output_function_name}, learning_algorithm_name, weigth_algorithm_name,'mse');
    % matrizFaixa                    : points that every input has value between 0 e 1
    % [numEscondidos numSaidas]      : points the quantity of hidden neurons and ouput neurons

    % Initialization of the weights of the net created (to help, type 'help init')
    rede = init(rede);
    echo on
    %   Parameters of training (to help, type 'help traingd')
    rede.trainParam.epochs   = 15000;    % Max number of iterations
    rede.trainParam.lr       = learning_rate;  % Learning rate
    rede.trainParam.goal     = 0;      % Minimum criteria of error during the training
    rede.trainParam.max_fail = 20;     % Maximum number of failures during the validation
    rede.trainParam.min_grad = 0;      % Critearia of minimum gradient
    rede.trainParam.show     = 10;     % Ireations shown at screen (filled with 'NaN', not shown at screen)
    rede.trainParam.time     = inf;    % Maximum time (in seconds) of the training
    echo off
    fprintf('\nTraining ...\n')

    conjuntoValidacao.P = entradasValidacao; % Validation input
    conjuntoValidacao.T = saidasValidacao;   % Expected output of validation

    %  Training the net
    [redeNova,desempenho,saidasRede,erros] = train(rede,entradasTreinamento,saidasTreinamento,[],[],conjuntoValidacao);
    % redeNova   : net after the training
    % desempenho : results
    %              desempenho.perf  - error vector of all iterations
    %              desempenho.vperf - validation error vector of all iterations
    %              desempenho.epoch - epoches vector executed
    % saidasRede : matriz with the ouput of the net for all training patterns
    % erros      : matriz with error for each training pattern
    %             (for each pattern: error = expected output - net output)
    % Obs.       : The two arguments of 'train' filled with  [] are only used when delays are used
    %             (for help, type 'help train')

    fprintf('\nTesting ...\n');

    %    Testing the net
    [saidasRedeTeste,Pf,Af,errosTeste,desempenhoTeste] = privatesim(redeNova,entradasTeste,[],[],saidasTeste);
    % saidasRedeTeste : matriz containing the outputs of the network for each test pattern
    % Pf,Af           : matrizes not used in this example (only when using delays )
    % errosTeste      : matriz containing errors for each test pattern
    %                  (for each pattern: error = expected output - net output)
    % desempenhoTeste : test error

    [maiorSaidaRede, nodoVencedorRede] = max (saidasRedeTeste);
    [maiorSaidaDesejada, nodoVencedorDesejado] = max (saidasTeste);

    %      Obs.: he command 'max' applied to an array generates two vectors : one containing the major elements of each column
    % And the other containing the rows where the largest elements of each column occurred .

    classificacoesErradas = 0;
    for padrao = 1 : numTeste;
        if nodoVencedorRede(padrao) ~= nodoVencedorDesejado(padrao),
            classificacoesErradas = classificacoesErradas + 1;
        end
    end
    erroClassifTeste = 100 * (classificacoesErradas/numTeste);
    %fprintf('Erro de classificacao para o conjunto de teste: %6.5f\n',erroClassifTeste);
    targets = saidasTeste;
    outputs = saidasRedeTeste;
    MSE_train = desempenho.perf(length(desempenho.perf));
    MSE_valid = desempenho.vperf(length(desempenho.vperf));
    MSE_test = desempenhoTeste;
    return;

end
