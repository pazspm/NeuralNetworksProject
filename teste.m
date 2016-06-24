number_neurons_input = [1,3,5,12,27];
length_vector_number = size(number_neurons_input,2);

learning_rate = [0.05,0.1,0.2,0.3,0.7,1.1];
length_vector_learning = size(learning_rate,2);

activation_function_name = {'tansig' 'logsig' 'purelin'};
length_vector_act = size(activation_function_name,2);

output_function_name = {'tansig' 'logsig' 'purelin'};
length_vector_out = size(output_function_name,2);

for y = 1:length_vector_out
    for k = 1:length_vector_act
        for j = 1:length_vector_learning
            for i = 1:length_vector_number
                outdir = sprintf('./Results/neruons_%d_learn_%g_act_', number_neurons_input(1,i),learning_rate(1,j));
                outdir = strcat(outdir,activation_function_name(1,k));
                outdir = strcat(outdir,'_out_');
                outdir = strcat(outdir,output_function_name(1,y));
                outdir = strcat(outdir,'/');
                disp(outdir);
            end
        end
    end
end